#! /bin/bash

echo "Remember: This script has to be run with superuser privileages."


##### Tailor GNOME Settings #####
# Set dark-mode
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set Fonts and sizes
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 12'
gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'Adwaita Mono 16' 

# Add missing window buttons 
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Add battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Remap caps-lock to escape
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

# Set time format to 24h
gsettings set org.gnome.desktop.interface clock-format '24h'

# Remove unnecessary stuff
dnf remove -y \
gnome-maps \
cheese \
totem \
rhythmbox \
gnome-contacts \
simple-scan \
yelp \
orca \
gnome-tour

# Update apps and system
dnf upgrade -y

# Install essential apps from dnf
dnf install -y --skip-unavailable \
thunderbird \
gimp \
zsh \
vim \
nvim \
steam \
python3-pip \
gnome-firmware \
sox \
fzf \
fastfetch \
ollama \
cmatrix \
docker \
gnome-tweaks

# Add myself to docker group (no sudo required)
usermod -aG docker $USER

# Install Nvidia drivers
echo "Installing NVIDIA drivers..."
dnf install -y --skip-unavailable \
akmod-nvidia \
xorg-x11-drv-nvidia-cuda \
xorg-x11-drv-nvidia-power \
nvidia-vaapi-driver \
vdpauinfo \
xorg-x11-drv-nvidia-cuda-libs \
kernel-headers \
kernel-devel

# Enable RPM Fusion if not already enabled (needed for NVIDIA drivers)
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 2>/dev/null || echo "RPM Fusion already installed or failed to install"

# Install System utilities
dnf install -y xrandr

# Install uv for python
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install and configure zsh and oh-my-zsh
echo "Installing and configuring zsh..."
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change default shell to zsh for the user
chsh -s $(which zsh) $SUDO_USER

echo "Note: You may need to log out and log back in for zsh to take effect"

# Flatpak apps
echo "Setting up Flatpak and installing apps..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y \
flathub com.mattjakeman.ExtensionManager \
flathub com.discordapp.Discord

# Install Visual Studio Code via dnf
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install -y code

# Clone .dotfiles from my other repository
echo "Cloning dotfiles..."
sudo -u $SUDO_USER git clone https://github.com/loureq177/dotfiles /home/$SUDO_USER/.dotfiles

# Create symlinks to those .files
sudo -u $SUDO_USER ln -sf /home/$SUDO_USER/.dotfiles/.zshrc /home/$SUDO_USER/.zshrc
sudo -u $SUDO_USER ln -sf /home/$SUDO_USER/.dotfiles/.gitconfig /home/$SUDO_USER/.gitconfig

# Fix lofree keyboard
echo 2 | tee /sys/module/hid_apple/parameters/fnmode
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="hid_apple.fnmode=2 /' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Clean up
dnf autoremove -y
dnf clean all -y

echo ""
echo "========================================"
echo "INSTALLATION COMPLETED!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Reboot your system for NVIDIA drivers to load properly"
echo "2. After reboot, run the GNOME extensions script as regular user:"
echo "   bash $(dirname "$0")/install_gnome_extensions.sh"
echo "3. Your default shell has been changed to zsh - it will take effect after logout-login or reboot"
echo ""
echo "Notes:"
echo "- NVIDIA drivers require a reboot to work properly"
echo "- If brightness is still flickering, try: sudo systemctl disable gdm && sudo systemctl enable gdm"
echo "- For GNOME extensions, use Extension Manager or visit https://extensions.gnome.org/"
