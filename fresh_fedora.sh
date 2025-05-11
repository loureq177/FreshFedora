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
gnome-tour

# Update apps and system
dnf upgrade -y

# Install essential apps
dnf install -y \
thunderbird\
gimp\
zsh\
vim

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

chsh -s /usr/bin/zsh

dnf autoremove -y
dnf clean all -y

# Configure git profile
git config --global user.name mlorenc
git config --global user.email 142215274+loureq177@users.noreply.github.com
git config --global init.defaultBranch main
