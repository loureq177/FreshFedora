#! /bin/bash

# Prevent shell switching during script execution
export SHELL=/bin/bash
export RUNZSH=no

if [ "$EUID" -ne 0 ]; then
  echo "Please, run again as a superuser"
  exit 1
fi

# Get the real user (not root)
REAL_USER=${SUDO_USER:-$(logname)}
REAL_HOME=$(eval echo ~$REAL_USER)
REAL_UID=$(id -u $REAL_USER)

echo "Running script for user: $REAL_USER"
echo "User home directory: $REAL_HOME"
echo "User UID: $REAL_UID"

# Fix permissions for XDG runtime directory if needed
if [ ! -d "/run/user/$REAL_UID" ]; then
    mkdir -p "/run/user/$REAL_UID"
    chown $REAL_USER:$REAL_USER "/run/user/$REAL_UID"
    chmod 700 "/run/user/$REAL_UID"
fi

# Fix SELinux contexts to prevent permission denied errors
echo "Fixing SELinux contexts..."
restorecon -R "/run/user/$REAL_UID" 2>/dev/null || true
setsebool -P use_fusefs_home_dirs 1 2>/dev/null || true

echo "Configuring GNOME settings..."
# Wait for GNOME to be available
sleep 2

# Prevent shell switching during script execution
export SHELL=/bin/bash
export RUNZSH=no

if [ "$EUID" -ne 0 ]; then
  echo "Please, run again as a superuser"
  exit 1
fi

# Get the real user (not root)
REAL_USER=${SUDO_USER:-$(logname)}
REAL_HOME=$(eval echo ~$REAL_USER)
REAL_UID=$(id -u $REAL_USER)

echo "Running script for user: $REAL_USER"
echo "User home directory: $REAL_HOME"
echo "User UID: $REAL_UID"

# Fix permissions for XDG runtime directory if needed
if [ ! -d "/run/user/$REAL_UID" ]; then
    mkdir -p "/run/user/$REAL_UID"
    chown $REAL_USER:$REAL_USER "/run/user/$REAL_UID"
    chmod 700 "/run/user/$REAL_UID"
fi

# Fix SELinux contexts to prevent permission denied errors
echo "Fixing SELinux contexts..."
restorecon -R "/run/user/$REAL_UID" 2>/dev/null || true
setsebool -P use_fusefs_home_dirs 1 2>/dev/null || true

echo "Configuring GNOME settings..."
# Wait for GNOME to be available
sleep 2

# Set dark-mode
echo "Setting dark theme..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' || echo "Failed to set GTK theme"
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || echo "Failed to set color scheme"
echo "Setting dark theme..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' || echo "Failed to set GTK theme"
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || echo "Failed to set color scheme"

# Set Fonts and sizes
echo "Setting fonts..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 12' || echo "Failed to set interface font"
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 12' || echo "Failed to set document font"
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface monospace-font-name 'Adwaita Mono 16' || echo "Failed to set monospace font"
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

# Add missing window buttons 
echo "Setting window buttons..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' || echo "Failed to set window buttons"
echo "Setting window buttons..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' || echo "Failed to set window buttons"

# Add battery percentage
echo "Setting battery percentage..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface show-battery-percentage true || echo "Failed to set battery percentage"
echo "Setting battery percentage..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface show-battery-percentage true || echo "Failed to set battery percentage"

# Remap caps-lock to escape
echo "Setting caps-lock to escape..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" || echo "Failed to set caps-lock mapping"
echo "Setting caps-lock to escape..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" || echo "Failed to set caps-lock mapping"

# Set time format to 24h
echo "Setting 24h time format..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface clock-format '24h' || echo "Failed to set clock format"

# Set microphone volume to 30%
echo "Setting microphone volume..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID PULSE_RUNTIME_PATH=/run/user/$REAL_UID/pulse pactl set-source-volume alsa_input.pci-0000_06_00.6.analog-stereo 30% || echo "Failed to set microphone volume"

echo "Adding Visual Studio Code repo..."
echo "Setting 24h time format..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID DISPLAY=:0 gsettings set org.gnome.desktop.interface clock-format '24h' || echo "Failed to set clock format"

# Set microphone volume to 30%
echo "Setting microphone volume..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID PULSE_RUNTIME_PATH=/run/user/$REAL_UID/pulse pactl set-source-volume alsa_input.pci-0000_06_00.6.analog-stereo 30% || echo "Failed to set microphone volume"

echo "Adding Visual Studio Code repo..."
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Removing unnecessary applications..."
dnf remove -y \
cheese \
gnome-contacts \
gnome-maps \
gnome-tour \
orca \
rhythmbox \
totem \
simple-scan \
yelp \

echo "Updating system..."
dnf upgrade -y

echo "Installing essential applications..."
dnf install -y --skip-unavailable \
cmatrix \
code \
docker \
fastfetch \
fzf \
gimp \
gnome-firmware \
gnome-tweaks \
nvim \
ollama \
ptyxis \
python3-pip \
sox \
stacer \
steam \
thunderbird \
tldr \
vim \
xrandr \
zsh

# Add Z-Shell to /etc/shells
echo "/usr/bin/zsh" | tee -a /etc/shells

# Add user to docker group (use real user, not root)
echo "Adding $REAL_USER to docker group..."
usermod -aG docker $REAL_USER || echo "Failed to add user to docker group"

# Start and enable docker service
systemctl enable docker || echo "Failed to enable docker service"
systemctl start docker || echo "Failed to start docker service"

# Install Nvidia drivers
# echo "Installing NVIDIA drivers..."
# dnf install -y --skip-unavailable \
# akmod-nvidia \
# xorg-x11-drv-nvidia-cuda \
# xorg-x11-drv-nvidia-power \
# nvidia-vaapi-driver \
# vdpauinfo \
# xorg-x11-drv-nvidia-cuda-libs \
# kernel-headers \
# kernel-devel

echo "Enabling RPM Fusion repositories, needed for NVIDIA drivers... "
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 2>/dev/null || echo "RPM Fusion already installed"

echo "Installing uv for Python..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME SHELL=/bin/bash bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh' || echo "Failed to install uv"

echo "Installing and configuring Z-Shell and Oh-My-Zsh..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME SHELL=/bin/bash RUNZSH=no bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' || echo "Failed to install Oh-My-Zsh"

# Change default shell to zsh for the user
chsh -s $(which zsh) $REAL_USER

echo "Setting up Flatpak and installing apps..."

# Setup Flatpak repository
echo "Setting up Flatpak repository..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Flatpak apps one by one with error handling
echo "Installing Discord..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME flatpak install -y flathub com.discordapp.Discord || echo "Failed to install Discord"

echo "Installing DBeaver..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME flatpak install -y flathub io.dbeaver.DBeaverCommunity || echo "Failed to install DBeaver"

echo "Installing Extension Manager..."
sudo -u $REAL_USER XDG_RUNTIME_DIR=/run/user/$REAL_UID HOME=$REAL_HOME flatpak install -y flathub com.mattjakeman.ExtensionManager || echo "Failed to install Extension Manager"

# Fix Lofree keyboard
# echo 2 | tee /sys/module/hid_apple/parameters/fnmode
# sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="hid_apple.fnmode=2 /' /etc/default/grub
# grub2-mkconfig -o /boot/grub2/grub.cfg

# Fix brightness issue
# grep -q acpi_backlight=vendor /etc/default/grub || \
# sed -i '/^GRUB_CMDLINE_LINUX=/ s/"$/ acpi_backlight=vendor"/' /etc/default/grub
# grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Cleaning up..."
dnf autoremove -y
dnf clean all -y

echo ""
echo "========================================"
echo "INSTALLATION COMPLETED!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Reboot your system for NVIDIA drivers to load properly"
echo "2. Your default shell has been changed to zsh - it will take effect after logout-login or reboot"
echo ""
echo "Notes:"
echo "- NVIDIA drivers require a reboot to work properly"
echo "- If brightness is still flickering, try: sudo systemctl disable gdm && sudo systemctl enable gdm"
echo "- For GNOME extensions, use Extension Manager or visit https://extensions.gnome.org/"
