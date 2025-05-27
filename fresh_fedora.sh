#! /bin/bash

# This script has to be run with superuser privileages.

# Install Z-Shell
######################################

# Remove unnecessary stuff
sudo dnf remove -y \
gnome-map\
cheese\
totem\
rhythmbox\
gnome-contacts\
simple-scan\
yelp\
orca\
gnome-tour\
gnome-tweaks

# Update apps and system
dnf upgrade -y

# Install essential apps from dnf
dnf install -y --skip-unavailable\
thunderbird\
gimp\
zsh\
vim\
python3-pip\
gnome-firmware\
sox\ # audio library for the `keep_JBL_alive.sh`
fzf\
fastfetch\
ollama\
cmatrix\

# Nvidia drivers
akmod-nvidia \
xorg-x11-drv-nvidia-cuda \
xorg-x11-drv-nvidia-power \
nvidia-vaapi-driver \
vdpauinfo\
xorg-x11-drv-nvidia-cuda-libs\
kernel-headers\
kernel-devel\

# System utilities
xrandr

# Flatpak apps
flatpak install -y\
flathub com.mattjakeman.ExtensionManager\
flathub com.discordapp.Discord\

# Install Visual Studio Code via dnf
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install code

# Clone .dotfiles from my other repository
git clone https://github.com/loureq177/dotfiles ~/.dotfiles

# Create symlinks to those .files
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# Fix brightness issue
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Fix lofree keyboard
echo 2 | tee /sys/module/hid_apple/parameters/fnmode
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="hid_apple.fnmode=2 /' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Tailor settings
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.interface show-battery-percentage true

dnf autoremove -y
dnf clean all -y
