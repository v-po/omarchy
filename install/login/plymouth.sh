#!/bin/bash

# PLYMOUTH SETUP
if [ "$(plymouth-set-default-theme)" != "omarchy" ]; then
  sudo cp -r "$HOME/.local/share/omarchy/default/plymouth" /usr/share/plymouth/themes/omarchy/
  sudo plymouth-set-default-theme -R omarchy
fi

# Keep plymouth running until graphical.target (so SDDM/KDE can fade in smoothly)
if [ ! -f /etc/systemd/system/plymouth-quit.service.d/wait-for-graphical.conf ]; then
  sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
  sudo tee /etc/systemd/system/plymouth-quit.service.d/wait-for-graphical.conf <<'EOF'
[Unit]
After=multi-user.target
EOF
fi

# Mask plymouth-quit-wait.service (avoids long boot hang)
if ! systemctl is-enabled plymouth-quit-wait.service | grep -q masked; then
  sudo systemctl mask plymouth-quit-wait.service
  sudo systemctl daemon-reload
fi
