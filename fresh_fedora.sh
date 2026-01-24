#! /usr/bin/env bash
set -euo pipefail

# =====================[ USER CHECK ]===================== #
if [ "$EUID" -eq 0 ]; then
  echo -e "\033[0;31m[ERROR] Please run as normal user (DO NOT USE SUDO to start script)"
  exit 1
fi

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# =====================[ COLORS & LOGGING ]===================== #
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

LOG_FILE="/tmp/fedora-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; sleep 2; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; sleep 2; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; sleep 2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; sleep 2; }

log_info "Running setup for user: $USER"
log_info "Home directory: $HOME"

# =====================[ GIT SETUP ]=================== #
log_info "Setting up git..."

git config --global init.defaultBranch main

CURRENT_NAME=$(git config --global --get user.name || true)
CURRENT_EMAIL=$(git config --global --get user.email || true)

if [[ -n "$CURRENT_NAME" ]] && [[ -n "$CURRENT_EMAIL" ]]; then
  log_info "Git is already configured as: $CURRENT_NAME <$CURRENT_EMAIL> — skipping setup."
else
  if [[ -z "$CURRENT_NAME" ]]; then
    read -p "Enter your nick for git config --global user.name: " username
    git config --global user.name "$username"
  fi

  if [[ -z "$CURRENT_EMAIL" ]]; then
    read -p "Enter your email for git config --global user.email: " email
    git config --global user.email "$email"
  fi

  log_ok "Git has been correctly set up."
fi

# =========================[ DRIVER UPDATE ]========================= #
log_info "Updating drivers..."
sudo fwupdmgr refresh --force || true
sudo fwupdmgr get-updates || true
sudo fwupdmgr update --assume-yes || true
log_ok "Drivers updated check complete!"

# =====================[ JETBRAINS MONO NERD FONT ]===================== #
log_info "Installing JetBrains Mono Nerd Font..."
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
FONT_DIR="/usr/share/fonts/JetBrainsMonoNerd"
if [ ! -d "$FONT_DIR" ]; then
  sudo mkdir -p "$FONT_DIR"
  curl -fLo /tmp/JetBrainsMono.zip "$FONT_URL" \
    && sudo unzip -qo /tmp/JetBrainsMono.zip -d "$FONT_DIR" \
    && sudo fc-cache -f -v \
    && log_ok "JetBrains Mono Nerd Font installed." \
    || log_warn "Failed to install JetBrains Mono Nerd Font."
else
  log_info "JetBrains Mono Nerd Font already installed — skipping."
fi

# =====================[ GNOME CONFIGURATION ]===================== #
log_info "Configuring GNOME environment..."
log_info "Applying GNOME preferences..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' || log_warn "GTK theme failed"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || log_warn "Color scheme failed"
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 12'
gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 16' \
  && log_ok "Default monospace font set to JetBrainsMono Nerd Font Mono." \
  || log_warn "Failed to set JetBrains Mono Nerd Font as default."
gsettings set org.gnome.desktop.interface text-scaling-factor 1.10
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.wm.preferences auto-raise true
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.peripherals.keyboard delay 200
log_ok "GNOME settings applied."

# =====================[ AUDIO ]===================== #
log_info "Setting microphone volume..."
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.3 && log_ok "Microphone set to 30%" || log_warn "Could not set volume"

# =====================[ DNF REPOS & UPDATES ]===================== #
log_info "Adding VS Code repository..."
if [ ! -f /etc/yum.repos.d/vscode.repo ]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
  log_ok "VS Code repo added."
else
  log_info "VS Code repository already exists — skipping."
fi
log_info "Enabling RPM Fusion repositories..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm || log_warn "RPM Fusion already installed"
log_ok "RPM Fusion enabled."

# =====================[ REMOVE DNF APPLICATIONS ]===================== #
log_info "Removing unnecessary applications..."
sudo dnf remove -y \
cheese \
firefox \
gnome-calendar \
gnome-contacts \
gnome-maps \
gnome-tour \
orca \
ptyxis \
simple-scan \
"libreoffice*" \
yelp
log_ok "Unnecessary applications removed."

# =====================[ UPDATE DNF APPLICATIONS ]===================== #
log_info "Updating system..."
sudo dnf upgrade -y
log_ok "System up to date."

# =====================[ FLATPAK SETUP ]===================== #
log_info "Setting up Flatpak repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
log_ok "Flathub repository ready."
flatpak_apps=(
  app.zen_browser.zen
  io.dbeaver.DBeaverCommunity
  com.mattjakeman.ExtensionManager
  md.obsidian.Obsidian
  com.spotify.Client
)
log_info "Installing Flatpak applications (batch mode)..."
flatpak install -y --system flathub "${flatpak_apps[@]}" \
  && log_ok "All Flatpak applications installed successfully." \
  || log_warn "There were issues installing some Flatpak applications."

# =====================[ DNF INSTALL PACKAGES ]===================== #
log_info "Installing essential applications..."
sudo dnf install -y --skip-unavailable \
  asciiquarium \
  bat \
  btop \
  cargo \
  cbonsai \
  cmatrix \
  code \
  curl \
  docker \
  fastfetch \
  file \
  fzf \
  gcc \
  git-lfs \
  gnome-extensions-app \
  gnome-firmware \
  gnome-tweaks \
  go \
  libavcodec-freeworld \
  make \
  nvim \
  ollama \
  procps-ng \
  python3-pip \
  rclone \
  rclone-browser \
  sox \
  stacer \
  steam \
  stow \
  tldr \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting
log_ok "Essential applications installed."

# =====================[ GROUP INSTALL ]===================== #
sudo dnf group install python-science -y
sudo dnf group install development-tools -y

# =====================[ CARGO INSTALL PACKAGES ]===================== #
cargo install eza

# =====================[ BREW INSTALL PACKAGES ]===================== #
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if ! grep -q "brew shellenv" "$HOME/.zshrc"; then
    log_info "Dodaję Homebrew do .zshrc..."
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$HOME/.zshrc"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
log_ok "Homebrew installed."

# =====================[ BREW APPS ]===================== #
brew install ghostty -y

# =====================[ EXTENSTIONS INSTALL ]===================== #
sudo dnf install -y --skip-unavailable \
  gnome-shell-extension-blur-my-shell \
  gnome-shell-extension-caffeine \
  gnome-shell-extension-drive-menu \
  gnome-shell-extension-gsconnect \
  gnome-shell-extension-system-monitor \
  gnome-shell-extension-no-overview

# =====================[ EXTENSTIONS ENABLE ]===================== #
gnome-extensions enable --quiet\
  blur-my-shell@aunetx || true \
  forge@jmmaranan.com || true \
  caffeine@patapon.info || true \
  gsconnect@andyholmes.github.io || true \
  drive-menu@gnome-shell-extensions.gcampax.github.com || true \
  system-monitor@gnome-shell-extensions.gcampax.github.com || true
  # || true gnome-shell-extension-no-overview

# =====================[ EXTENSTIONS DISABLE ]===================== #
gnome-extensions disable background-logo@fedorahosted.org || true

# =====================[ DOCKER SETUP ]===================== #
log_info "Configuring Docker..."
sudo usermod -aG docker $USER || log_warn "Failed to add user to docker group"
sudo systemctl enable docker || log_warn "Failed to enable docker"
sudo systemctl start docker || log_warn "Failed to start docker"
log_ok "Docker configured."

# =====================[ NVIDIA DRIVERS ]===================== #
log_info "Installing NVIDIA drivers for Wayland-only environment..."
sudo dnf install -y --skip-unavailable \
  akmod-nvidia \
  xorg-x11-drv-nvidia-cuda \
  nvidia-vaapi-driver \
  libva-utils \
  vdpauinfo \
  kernel-devel \
  kernel-headers \
  nvidia-gpu-firmware
log_info "Enabling NVIDIA power management services..."
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
log_info "Waiting for NVIDIA kernel module to build (this may take a few minutes)..."
sudo akmods --force
sudo dracut -f
log_ok "NVIDIA drivers installed. Services enabled for stability."

# =====================[ UV INSTALLER ]===================== #
log_info "Installing uv for Python..."
if command -v uv &> /dev/null; then
    log_info "uv already installed — skipping."
else
    log_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# =====================[ STARSHIP PROMPT ]===================== #
log_info "Installing Starship Prompt..."
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  log_ok "Starship binary installed."
else
  log_info "Starship already installed — skipping binary download."
fi
STARSHIP_INIT='eval "$(starship init zsh)"'
if ! grep -qF "$STARSHIP_INIT" "$HOME/.zshrc"; then
  echo "" >> "$HOME/.zshrc"
  echo "$STARSHIP_INIT" >> "$HOME/.zshrc"
  log_ok "Added Starship init to .zshrc"
else
  log_info "Starship already configured in .zshrc — skipping."
fi

# =====================[ SET ZSH AS DEFAULT ]===================== #
log_info "Setting ZSH as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
    log_ok "Shell changed to ZSH. It will take effect after logout/login."
else
    log_info "ZSH is already your default shell."
fi

# =====================[ MOUNTING EXTERNAL HOME ]===================== #
log_info "Configuring 512 GB drive..."
UUID="688f55cd-90c1-4766-b4f9-5e1a812fe16a"
if ! grep -q "$UUID" /etc/fstab; then
    sudo sed -i '/[[:space:]]\/home[[:space:]]/d' /etc/fstab
    echo "UUID=$UUID /home ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null
fi
sudo mount -a
if [ "$(stat -c '%U' /home/$USER 2>/dev/null)" != "$USER" ]; then
    sudo chown -R $USER:$USER /home/$USER
    sudo chmod 700 /home/$USER
fi
log_ok "Home drive ready."

# =====================[ CLEANUP ]===================== #
log_info "Cleaning up..."
sudo dnf autoremove -y
sudo dnf clean all -y
log_ok "System cleanup complete."

# =====================[ FINISH ]===================== #
echo ""
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} INSTALLATION COMPLETED SUCCESSFULLY!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Logs saved to: $LOG_FILE"
echo ""
echo "Reboot your system for NVIDIA drivers to load properly."
