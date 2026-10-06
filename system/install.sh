#!/usr/bin/env bash
# Copy the system files in this folder back to / (Linux only, needs sudo).
# Files are mirrored by path: system/etc/foo -> /etc/foo. Any existing file
# that differs is first backed up to ~/.dotfiles-backup/system-<timestamp>/,
# outside the live dirs: systemd runs every executable in system-sleep/, so a
# .bak left next to kbd.sh would run too. Safe to re-run.
set -euo pipefail

cd "$(dirname "$0")"

backup_dir="$HOME/.dotfiles-backup/system-$(date +%Y%m%d%H%M%S)"
rebuild_initramfs=false
reload_udev=false

while IFS= read -r -d '' src; do
	dest="/$src"

	if [ -e "$dest" ]; then
		if cmp -s "$src" "$dest"; then
			echo "Unchanged: $dest"
			continue
		fi
		mkdir -p "$backup_dir/$(dirname "$src")"
		cp -a "$dest" "$backup_dir/$src"
		echo "Backed up $dest -> $backup_dir/$src"
	fi

	# Git only tracks the executable bit, so set modes explicitly.
	mode=644
	[ -x "$src" ] && mode=755
	sudo install -D -o root -g root -m "$mode" "$src" "$dest"
	echo "Installed: $dest"

	case "$dest" in
	/etc/modprobe.d/* | /etc/mkinitcpio.conf.d/*) rebuild_initramfs=true ;;
	/etc/udev/rules.d/*) reload_udev=true ;;
	esac
done < <(find etc usr -type f -print0)

if $reload_udev; then
	sudo udevadm control --reload-rules
	sudo udevadm trigger --subsystem-match=leds
fi

# Module options and early-load lists are baked into the initramfs.
if $rebuild_initramfs; then
	echo "Rebuilding initramfs..."
	if command -v limine-mkinitcpio >/dev/null 2>&1; then
		sudo limine-mkinitcpio
	else
		sudo mkinitcpio -P
	fi
	echo "Reboot for the GPU module changes to take effect."
fi
