# FreshFedora

A comprehensive script to set up a fresh install of Fedora Linux with personalized settings and applications.

## Features

### GNOME Settings
- ✅ Dark mode
- ✅ 24-hour time format  
- ✅ Custom fonts (Adwaita Sans 12, Adwaita Mono 16)
- ✅ Window buttons (minimize, maximize, close)
- ✅ Battery percentage display
- ✅ Caps Lock remapped to Escape

### System Updates & Cleanup
- ✅ System upgrade
- ✅ Remove unnecessary GNOME applications
- ✅ Install essential applications

### Applications Installed
- **Communication**: Thunderbird, Discord
- **Development**: VS Code, vim, nvim, git, python3-pip, docker
- **Media**: GIMP, Steam
- **System**: gnome-tweaks, gnome-firmware, Extension Manager
- **Terminal**: zsh, oh-my-zsh, fzf, fastfetch, cmatrix
- **Other**: ollama, sox, uv (Python package manager)

### Shell Setup
- ✅ Zsh installation and configuration
- ✅ Oh-my-zsh installation  
- ✅ Dotfiles integration from GitHub
- ✅ Zsh set as default shell

### Graphics & Drivers
- ✅ NVIDIA drivers installation
- ✅ RPM Fusion repositories
- ✅ Hardware acceleration support

### GNOME Extensions
- Basic extensions installed via DNF
- Extension Manager for additional extensions
- Helper script for popular extensions

## Usage

### Prerequisites
- Fresh Fedora Linux installation
- Internet connection
- Administrator privileges

### Installation

1. **Download the script:**
   ```bash
   git clone <your-repo-url>
   cd FreshFedora
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x fresh_fedora.sh
   chmod +x install_gnome_extensions.sh
   ```

3. **Run the main script with sudo:**
   ```bash
   sudo ./fresh_fedora.sh
   ```

4. **Reboot your system:**
   ```bash
   sudo reboot
   ```

5. **After reboot, install additional GNOME extensions (optional):**
   ```bash
   ./install_gnome_extensions.sh
   ```

## Post-Installation

### Verification
After reboot, verify that everything works:

1. **Test NVIDIA drivers:**
   ```bash
   nvidia-smi
   ```

2. **Check default shell:**
   ```bash
   echo $SHELL
   # Should output: /usr/bin/zsh
   ```

3. **Test caps-lock to escape mapping:**
   - Press Caps Lock key - it should act as Escape

4. **Check GNOME settings:**
   - Dark mode should be enabled
   - Battery percentage should be visible
   - Time should be in 24-hour format

### Recommended GNOME Extensions
Use Extension Manager to install:
- Dash to Dock
- AppIndicator Support  
- User Themes
- Vitals
- GSConnect
- Clipboard Indicator
- Sound Input & Output Device Chooser

## Troubleshooting

### Common Issues

**NVIDIA drivers not working:**
- Ensure secure boot is disabled in BIOS
- Reboot and wait for akmods to build drivers
- Check with: `nvidia-smi`

**Zsh not default shell:**
- Log out and log back in
- Or run: `chsh -s $(which zsh)`

**Caps Lock not remapped:**
- Try logging out and back in
- Check GNOME settings: Settings > Keyboard > Special Character Entry

**Extensions not working:**
- Install "User Themes" extension first
- Restart GNOME Shell: Alt+F2, type 'r', press Enter

## Files

- `fresh_fedora.sh` - Main installation script
- `install_gnome_extensions.sh` - Helper script for GNOME extensions
- `README.md` - This documentation

## Customization

Edit `fresh_fedora.sh` to:
- Add/remove applications in the DNF install section
- Modify GNOME settings
- Change dotfiles repository URL
- Add custom configurations

## Notes

- Script requires superuser privileges for system modifications
- Personal dotfiles are cloned from GitHub (update the URL in script)
- Some changes require a reboot to take effect
- NVIDIA driver installation may take time during first boot
