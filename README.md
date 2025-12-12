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
- ✅ Keyboard repeat delay tweak

### Audio

- ✅ Sets default microphone volume to 30%

### System Updates & Cleanup

- ✅ Firmware update check (via `fwupdmgr`)
- ✅ System upgrade (`dnf upgrade`)
- ✅ Remove unnecessary GNOME applications (cheese, firefox, gnome-calendar, gnome-contacts, gnome-maps, gnome-tour, orca, simple-scan, yelp)
- ✅ Autoremove + DNF cache cleanup
- ✅ Install essential applications

### Applications Installed

#### Installed via DNF

- **Development**: VS Code (`code`), vim, nvim, git-lfs, gcc, make, go, docker, python3-pip
- **Media**: GIMP, Steam, sox
- **System**: gnome-tweaks, gnome-firmware, stacer
- **Terminal**: zsh, zsh-autosuggestions, fzf, starship, fastfetch, btop, cmatrix, asciiquarium, cbonsai, tldr
- **Other**: ollama, rclone, rclone-browser

#### Installed via Flatpak (Flathub)

- Zen Browser
- DBeaver Community
- Extension Manager
- Obsidian
- Spotify

#### Installed via installer script

- `uv` (Astral installer)

### Fonts

- ✅ JetBrainsMono Nerd Font installation
- ✅ Set as default monospace font in GNOME

### Shell Setup

- ✅ Zsh installation and configuration
- ✅ Oh-my-zsh installation
- ✅ Zsh set as default shell
- ✅ Starship prompt installed and enabled for Zsh

### Graphics & Drivers

- ✅ NVIDIA drivers installation (akmod-nvidia, CUDA support)
- ✅ RPM Fusion repositories (free & nonfree)
- ✅ Hardware acceleration support (libavcodec-freeworld)

### Docker

- ✅ Docker installation and configuration
- ✅ User added to docker group
- ✅ Docker service enabled and started

### Installation

#### Prerequisites

- Fedora Workstation
- Working internet connection
- `sudo` access for your user
- On a typical Fedora Workstation install you already have: `curl`, `unzip`, `flatpak`, `fwupdmgr`, `gsettings`, `wpctl`

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

All installation steps are logged to: `/tmp/fedora-setup.log`

View logs with:

```bash
cat /tmp/fedora-setup.log
```
