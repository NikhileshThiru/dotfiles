# dotfiles

Neovim, tmux and Ghostty configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level folder is a Stow package laid out the way its files sit under `$HOME`:

```
nvim/.config/nvim/        ->  ~/.config/nvim/
tmux/.tmux.conf           ->  ~/.tmux.conf
ghostty/.config/ghostty/  ->  ~/.config/ghostty/
```

## Setting up a new machine

### 1. Install the tools

**macOS**

```sh
brew install git stow neovim tmux ripgrep fzf tree-sitter-cli
brew install --cask ghostty
```

**Linux (Debian/Ubuntu shown; use dnf/pacman equivalents elsewhere)**

```sh
sudo apt install git stow tmux ripgrep fzf curl tar build-essential
# Clipboard support for nvim: pick one
sudo apt install wl-clipboard   # Wayland
sudo apt install xclip          # X11
```

- **Neovim 0.12+** is required (the config uses the built-in `vim.pack`). Distro packages
  are often older; grab a build from <https://github.com/neovim/neovim/releases>.
- **tree-sitter CLI 0.26.1+** is needed by nvim-treesitter to build parsers:
  <https://github.com/tree-sitter/tree-sitter/releases> or `cargo install tree-sitter-cli`.
- **Ghostty**: <https://ghostty.org/docs/install/binary>

### 2. Clone and link

```sh
git clone https://github.com/NikhileshThiru/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` moves any existing nvim/tmux/Ghostty config to `<name>.bak.<timestamp>`, then
runs `stow`. It's safe to re-run.

To do it by hand instead: `cd ~/dotfiles && stow nvim tmux ghostty`
(on Linux use `stow --no-folding --ignore='macos\.conf' ghostty` for Ghostty).

### 3. First launch

- Open `nvim`. Plugins install at the revisions pinned in `nvim-pack-lock.json`, and
  Treesitter parsers build on first start.
- Language servers and formatters (lua-language-server, pyright, stylua, black, prettierd,
  etc.) are installed from `:Mason`.
- Icons need a Nerd Font. Ghostty ships with Nerd Font symbols built in; other terminals
  need one installed (e.g. `brew install --cask font-jetbrains-mono-nerd-font`).

## Day to day

- The files under `~/.config/...` are symlinks into this repo, so edit them in place and
  commit from `~/dotfiles`.
- Plugin updates (`:lua vim.pack.update()`) rewrite `nvim-pack-lock.json`; commit it so
  other machines get the same versions. On another machine, `git pull` then `:restart`.
- Add another config as a new package, e.g. zsh:
  `mkdir zsh && mv ~/.zshrc zsh/ && stow zsh`
- Unlink a package: `stow -D <package>`

## macOS vs Linux

- **Ghostty**: macOS-only settings go in `ghostty/.config/ghostty/macos.conf`, loaded with
  `config-file = ?macos.conf`. `install.sh` doesn't link it on Linux, and the `?` keeps
  Ghostty from complaining that it's missing.
- **tmux**: macOS-only settings go inside the `if-shell 'uname | grep -q Darwin'` block at
  the end of `.tmux.conf`.
