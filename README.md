# FreshFedora

A comprehensive script to set up a fresh install of Fedora Linux with personalized settings and applications.

## Features

### GNOME Settings

- ✅ Dark mode (Adwaita-dark theme)
- ✅ 24-hour time format  
- ✅ Custom fonts (Adwaita Sans 12, JetBrainsMono Nerd Font Mono 16)
- ✅ Window buttons (minimize, maximize, close)
- ✅ Battery percentage display
- ✅ Caps Lock remapped to Escape
- ✅ Text scaling (1.10)

### System Updates & Cleanup

- ✅ System upgrade
- ✅ Remove unnecessary GNOME applications (cheese, firefox, gnome-contacts, gnome-maps, gnome-tour, orca, simple-scan, yelp)
- ✅ Install essential applications

### Applications Installed

- **Communication**: Discord (Flatpak)
- **Development**: VS Code, vim, nvim, git-lfs, gcc, make, go, docker, python3-pip, uv, DBeaver (Flatpak)
- **Media**: GIMP, Steam
- **System**: gnome-tweaks, gnome-firmware, Extension Manager (Flatpak), stacer, xrandr
- **Terminal**: zsh, zsh-autosuggestions, oh-my-zsh, fzf, fastfetch, btop, cmatrix, asciiquarium, cbonsai
- **Browsers**: Zen Browser (Flatpak)
- **Productivity**: Obsidian (Flatpak)
- **Other**: ollama, sox, rclone, rclone-browser, tldr

### Fonts

- ✅ JetBrainsMono Nerd Font installation
- ✅ Set as default monospace font in GNOME

### Shell Setup

- ✅ Zsh installation and configuration
- ✅ Oh-my-zsh installation  
- ✅ Zsh autosuggestions plugin
- ✅ Zsh set as default shell
- ✅ as default shell

### Graphics & Drivers

- ✅ NVIDIA drivers installation (akmod-nvidia, CUDA support)
- ✅ RPM Fusion repositories (free & nonfree)
- ✅ Hardware acceleration support (libavcodec-freeworld)

### Docker

- ✅ Docker installation and configuration
- ✅ User added to docker group
- ✅ Docker service enabled and started

### Installation

1. **Download the script:**

   ```bash
   git clone https://github.com/loureq177/FreshFedora.git
   cd FreshFedora
   ```

2. **Make script executable:**

   ```bash
   chmod +x fresh_fedora.sh
   ```

3. **Run the main script:**

   ```bash
   ./fresh_fedora.sh
   ```

4. **Reboot your system:**

   ```bash
   sudo reboot
   ```

## Logging

All installation steps are logged to: `/var/log/fedora-setup.log`

View logs with:

```bash
sudo cat /var/log/fedora-setup.log
```
