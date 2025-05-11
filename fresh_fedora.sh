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
gimp

flatpak install -y com.mattjakeman.ExtensionManager


# Install Visual Studio Code via dnf
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code

# Fix brightness issue
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

dnf autoremove -y
dnf clean all -y
