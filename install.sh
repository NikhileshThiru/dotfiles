#!/usr/bin/env bash
# Link these dotfiles into $HOME with GNU Stow. Safe to re-run.
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
	cat >&2 <<-'EOF'
	GNU Stow is not installed. Install it first:
	  macOS:          brew install stow
	  Debian/Ubuntu:  sudo apt install stow
	  Fedora:         sudo dnf install stow
	  Arch:           sudo pacman -S stow
	EOF
	exit 1
fi

# Move an existing real config out of the way so stow can link over it
# (e.g. the template Ghostty writes on first launch). Leaves symlinks, and
# directories that only hold symlinks, alone so re-runs are a no-op.
backup() {
	local target="$HOME/$1"
	[ -e "$target" ] || [ -L "$target" ] || return 0
	[ -L "$target" ] && return 0
	if [ -d "$target" ] && [ -z "$(find "$target" ! -type l ! -type d -print -quit)" ]; then
		return 0
	fi
	local dest
	dest="$target.bak.$(date +%Y%m%d%H%M%S)"
	echo "Backing up $target -> $dest"
	mv "$target" "$dest"
}

backup .config/nvim
backup .tmux.conf
backup .config/ghostty
backup .config/yazi

stow --restow nvim tmux yazi

# Global git ignore (~/.config/git/ignore) that keeps agent files out of every
# repo. --no-folding keeps ~/.config/git a real directory.
backup .config/git/ignore
stow --restow --no-folding git
if git config --global --get core.excludesFile >/dev/null 2>&1; then
	echo "Note: core.excludesFile is set, so git skips ~/.config/git/ignore." \
		"Unset it with: git config --global --unset core.excludesFile" >&2
fi

# Agent rules: one file that Claude Code reads as CLAUDE.md and Codex reads as
# AGENTS.md, plus the /handoff skill. Linked here rather than with stow because
# the global ignore above would hide files with those names in this repo too.
backup .claude/CLAUDE.md
backup .codex/AGENTS.md
backup .claude/skills/handoff
mkdir -p "$HOME/.claude/skills" "$HOME/.codex"
ln -snf "$PWD/agents/rules.md" "$HOME/.claude/CLAUDE.md"
ln -snf "$PWD/agents/rules.md" "$HOME/.codex/AGENTS.md"
ln -snf "$PWD/agents/handoff" "$HOME/.claude/skills/handoff"

# Claude Code writes to its own settings.json, so it isn't linked. Merge in the
# shared parts instead: block git commit/push and drop commit/PR attribution.
settings="$HOME/.claude/settings.json"
if command -v jq >/dev/null 2>&1; then
	[ -s "$settings" ] || echo '{}' >"$settings"
	merged=$(jq '
		.permissions.deny = ((.permissions.deny // []) + [
			"Bash(git commit *)", "Bash(git push *)",
			"Bash(git -C * commit *)", "Bash(git -C * push *)"
		] | unique)
		| .attribution = {commit: "", pr: "", sessionUrl: false}' "$settings")
	printf '%s\n' "$merged" >"$settings"
else
	echo "jq not found: skipped the git block and attribution in $settings." >&2
fi

# Link only this OS's Ghostty file (macos.conf or linux.conf). --no-folding
# links files one by one; without it stow links the whole directory and the
# ignore has no effect.
if [ "$(uname)" = Darwin ]; then
	stow --restow --no-folding --ignore='linux\.conf' ghostty
	echo "Linked nvim, tmux, yazi, git, agent rules and ghostty into $HOME."
	exit 0
fi

stow --restow --no-folding --ignore='macos\.conf' ghostty

# --- Linux (Omarchy) only ---
for pkg in hypr fastfetch btop cava voxtype spicetify; do
	backup ".config/$pkg"
done
backup .config/starship.toml
backup .bashrc
backup .local/bin/jarvis

stow --restow hypr fastfetch btop cava starship voxtype spicetify bash
# Keep ~/.local/bin a real directory so other tools don't install into the repo.
stow --restow --no-folding bin

# These dirs also hold files that aren't tracked (GTK bookmarks, Omarchy's own
# config), so link file by file and only back up the tracked files.
for file in .config/gtk-3.0/gtk.css .config/gtk-4.0/gtk.css .config/omarchy/shell.toml \
	.config/xdg-desktop-portal/hyprland-portals.conf .config/xdg-desktop-portal-termfilechooser/config; do
	backup "$file"
done
stow --restow --no-folding gtk omarchy portal

# GTK3 apps use adw-gtk3-dark (pacman: adw-gtk-theme) so gtk-3.0/gtk.css applies.
if command -v gsettings >/dev/null 2>&1 && [ -d /usr/share/themes/adw-gtk3-dark ]; then
	gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
fi

# btop's theme follows Omarchy through this link. Omarchy creates it at install
# time and it points into $HOME, so it isn't tracked; recreate it if missing.
mkdir -p "$HOME/.config/btop/themes"
[ -e "$HOME/.config/btop/themes/current.theme" ] ||
	ln -snf "$HOME/.local/state/omarchy/current/theme/btop.theme" "$HOME/.config/btop/themes/current.theme"

echo "Linked nvim, tmux, yazi, git, agent rules, ghostty and the Linux packages into $HOME."
