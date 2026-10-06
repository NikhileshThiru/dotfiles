#!/usr/bin/env bash
# Reinstall the packages listed in pacman.txt (official/Omarchy repos) and
# aur.txt (AUR, via yay). Already-installed packages are skipped. Safe to re-run.
#
# Refresh the lists after installing or removing things:
#   pacman -Qqen > packages/pacman.txt
#   pacman -Qqem > packages/aur.txt
set -euo pipefail

cd "$(dirname "$0")"

sudo pacman -Syu --needed - <pacman.txt

if [ -s aur.txt ]; then
	if ! command -v yay >/dev/null 2>&1; then
		echo "yay is not installed; skipping AUR packages in aur.txt." >&2
		exit 1
	fi
	yay -S --needed - <aur.txt
fi
