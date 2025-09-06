#!/bin/bash
#   1password-beta \
#   1password-cli \
#   asdcontrol-git \
#   cups \
#   cups-browsed \
#   cups-filters \
#   cups-pdf \
#   docker \
#   docker-buildx \
#   docker-compose \
#   github-cli \
#   luarocks \
#   obs-studio \
#   obsidian \
#   omarchy-chromium \
#   signal-desktop \
#   spotify \
#   system-config-printer \
#   ufw-docker \
#   typora \
#   ttf-ia-writer \

#   cargo \
#   gcc14 \

# TO-ADD-POST-INSTALL:
#   localsend \
#   pinta \
#   python-terminaltexteffects \
#   walker-bin \
#   tzupdate \
#   wf-recorder \
#   wl-screenrec \
#   yaru-icon-theme \
#   yay \

sudo pacman -S --noconfirm --needed rustup

rustup default stable

sudo pacman -S --noconfirm --needed \
  alacritty \
  avahi \
  bash-completion \
  bat \
  blueberry \
  brightnessctl \
  btop \
  clang \
  dust \
  evince \
  eza \
  fastfetch \
  fcitx5 \
  fcitx5-gtk \
  fcitx5-qt \
  fd \
  ffmpegthumbnailer \
  firefox \
  fontconfig \
  fzf \
  gnome-calculator \
  gnome-keyring \
  gnome-themes-extra \
  gum \
  gvfs-mtp \
  gvfs-smb \
  hypridle \
  hyprland \
  hyprland-qtutils \
  hyprlock \
  hyprpicker \
  hyprshot \
  hyprsunset \
  imagemagick \
  impala \
  imv \
  inetutils \
  iwd \
  jq \
  kdenlive \
  kvantum-qt5 \
  lazydocker \
  lazygit \
  less \
  libqalculate \
  libreoffice \
  llvm \
  mako \
  man \
  mariadb-libs \
  mise \
  mpv \
  nautilus \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  noto-fonts-extra \
  nss-mdns \
  nvim \
  pamixer \
  plasma-meta \
  sddm \
  playerctl \
  plocate \
  plymouth \
  polkit-gnome \
  postgresql-libs \
  power-profiles-daemon \
  python-gobject \
  python-poetry-core \
  qt5-wayland \
  ripgrep \
  satty \
  slurp \
  starship \
  sushi \
  swaybg \
  swayosd \
  tldr \
  tree-sitter-cli \
  ttf-cascadia-mono-nerd \
  ttf-jetbrains-mono-nerd \
  ufw \
  unzip \
  uwsm \
  waybar \
  whois \
  wiremix \
  wireplumber \
  wl-clip-persist \
  wl-clipboard \
  woff2-font-awesome \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  xmlstarlet \
  xournalpp \
  zoxide
