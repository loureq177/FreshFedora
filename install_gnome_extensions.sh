#!/bin/bash

# Script to install popular GNOME extensions after reboot
# This script should be run as regular user (not root)

echo "Installing popular GNOME extensions..."

# Check if Extension Manager is installed
if ! command -v gnome-extensions &> /dev/null && ! flatpak list | grep -q ExtensionManager; then
    echo "Extension Manager not found. Please install it first:"
    echo "flatpak install flathub com.mattjakeman.ExtensionManager"
    exit 1
fi

# Popular extensions with their IDs
declare -A extensions=(
    ["307"]="Dash to Dock"
    ["779"]="Clipboard Indicator"
    ["517"]="Caffeine"
)

echo "Please install these extensions manually via Extension Manager or browser:"
echo ""
for id in "${!extensions[@]}"; do
    echo "$id. ${extensions[$id]} - https://extensions.gnome.org/extension/$id/"
done

echo ""
echo "How to install:"
echo "1. Open Extension Manager from your applications"
echo "2. Search for the extension name"
echo "3. Click Install"
echo ""
echo "OR visit https://extensions.gnome.org/ in Firefox and install browser addon for one-click installs"

# Enable extensions if gnome-extensions command is available
if command -v gnome-extensions &> /dev/null; then
    echo ""
    echo "Available extensions on your system:"
    gnome-extensions list
fi
