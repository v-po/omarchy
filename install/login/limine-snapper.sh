#!/bin/bash

if ! command -v limine &>/dev/null; then
    exit 0
fi

# -------------------------------
# Setup mkinitcpio hooks for Omarchy
# -------------------------------
sudo tee /etc/mkinitcpio.conf.d/omarchy_hooks.conf >/dev/null <<EOF
HOOKS=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt filesystems fsck btrfs-overlayfs)
EOF

# -------------------------------
# Detect EFI
# -------------------------------
EFI_CONF="/boot/limine/limine.conf"
[[ -f /boot/EFI/limine/limine.conf ]] && EFI=true && EFI_CONF="/boot/EFI/limine/limine.conf"

# -------------------------------
# Extract existing cmdline
# -------------------------------
CMDLINE=$(grep "^[[:space:]]*cmdline:" "$EFI_CONF" | head -1 | sed 's/^[[:space:]]*cmdline:[[:space:]]*//')

# -------------------------------
# Configure Limine defaults
# -------------------------------
sudo tee /etc/default/limine >/dev/null <<EOF
TARGET_OS_NAME="Omarchy"
ESP_PATH="/boot"

KERNEL_CMDLINE[default]="$CMDLINE"
KERNEL_CMDLINE[default]+=" quiet splash"

ENABLE_UKI=yes
ENABLE_LIMINE_FALLBACK=yes

FIND_BOOTLOADERS=yes
BOOT_ORDER="*, *fallback, Snapshots"
MAX_SNAPSHOT_ENTRIES=5
SNAPSHOT_FORMAT_CHOICE=5
EOF

# Disable UKI/fallback if not EFI
[[ -z $EFI ]] && sudo sed -i '/^ENABLE_UKI=/d; /^ENABLE_LIMINE_FALLBACK=/d' /etc/default/limine

# -------------------------------
# Limine config
# -------------------------------
sudo tee /boot/limine.conf >/dev/null <<EOF
### Read more at: https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
#timeout: 3
default_entry: 2
interface_branding: Omarchy Bootloader
interface_branding_color: 2
hash_mismatch_panic: no

term_background: 1a1b26
backdrop: 1a1b26

# Tokyo Night terminal palette
term_palette: 15161e;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;a9b1d6
term_palette_bright: 414868;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;c0caf5

# Text colors
term_foreground: c0caf5
term_foreground_bright: c0caf5
term_background_bright: 24283b
EOF

# -------------------------------
# Install Limine helpers
# -------------------------------
# sudo pacman -S --noconfirm --needed limine-snapper-sync limine-mkinitcpio-hook

# -------------------------------
# Update Limine boot entries
# -------------------------------
sudo limine-update

# -------------------------------
# Snapper configs
# -------------------------------
if [ -z "${OMARCHY_CHROOT_INSTALL:-}" ]; then
    for cfg in root home; do
        if ! sudo snapper list-configs 2>/dev/null | grep -q "$cfg"; then
            sudo snapper -c "$cfg" create-config $([[ "$cfg" == "root" ]] && echo "/" || echo "/home")
        fi
    done
fi

# Tweak Snapper defaults
sudo sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="no"/; s/^NUMBER_LIMIT="50"/NUMBER_LIMIT="5"/; s/^NUMBER_LIMIT_IMPORTANT="10"/NUMBER_LIMIT_IMPORTANT="5"/' /etc/snapper/configs/{root,home}

# Enable limine-snapper-sync service
chrootable_systemctl_enable limine-snapper-sync.service

# Only rebuild initramfs if EFI/ESP exists
if [[ -d /boot ]] && [[ -f /etc/default/limine ]]; then
    echo "Rebuilding initramfs with Limine support..."
    sudo limine-mkinitcpio
fi
# -------------------------------
# Add UKI entry for EFI systems (skip on AMI BIOS)
# -------------------------------
if [[ -n "$EFI" ]] && efibootmgr &>/dev/null && ! efibootmgr | grep -q Omarchy &&
   ! grep -qi "American Megatrends" /sys/class/dmi/id/bios_vendor 2>/dev/null; then
    sudo efibootmgr --create \
        --disk "$(findmnt -n -o SOURCE /boot | sed 's/p\?[0-9]*$//')" \
        --part "$(findmnt -n -o SOURCE /boot | grep -o 'p\?[0-9]*$' | sed 's/^p//')" \
        --label "Omarchy" \
        --loader "\\EFI\\Linux\\$(cat /etc/machine-id)_linux.efi"
fi
