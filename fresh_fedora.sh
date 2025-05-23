#! /bin/bash

# This script has to be run with superuser privileages.


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
dnf install -y \
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


flatpak install -y\
com.mattjakeman.ExtensionManager\
flathub com.discordapp.Discord\
flathub com.spotify.Client

# Install Visual Studio Code via dnf
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install code

# Fix brightness issue
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Fix lofree keyboard
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="hid_apple.fnmode=2 /' /etc/default/grub
chsh -s /usr/bin/zsh

# Tailor settings
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.interface show-battery-percentage true

dnf autoremove -y
dnf clean all -y

# Configure git profile
git config --global user.name mlorenc
git config --global user.email 142215274+loureq177@users.noreply.github.com
git config --global init.defaultBranch main
