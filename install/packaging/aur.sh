#!/bin/bash
set -eE

echo "[Omarchy] Installing AUR helper and packages..."

# Ensure yay is available
if ! command -v yay >/dev/null; then
  sudo pacman -Sy --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  pushd "$tmpdir/yay"
  makepkg -si --noconfirm
  popd
  rm -rf "$tmpdir"
fi

# Pre-remove rust (to avoid rust vs rustup conflict)
# if pacman -Qi rust >/dev/null 2>&1; then
#   echo
#   echo "Rust detected. Uninstalling... "
#   echo
#   sudo pacman -R --noconfirm rust
# fi

# Install AUR packages non-interactively
# pinta
# wl-screenrec
yay -S --noconfirm --needed --removemake python-terminaltexteffects \
  tzupdate walker-bin yaru-icon-theme \
  limine-snapper-sync limine-mkinitcpio-hook
