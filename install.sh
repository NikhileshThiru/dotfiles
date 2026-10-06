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

stow --restow nvim tmux

if [ "$(uname)" = Darwin ]; then
	stow --restow ghostty
else
	# Skip macos.conf on Linux. --no-folding links files one by one; without it
	# stow links the whole directory and the ignore has no effect.
	stow --restow --no-folding --ignore='macos\.conf' ghostty
fi

echo "Linked nvim, tmux and ghostty into $HOME."
