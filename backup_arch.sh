#!/bin/bash

# Configuration
BACKUP_DIR="$HOME/Documents/backup-arch/backup-$(date +'%Y%m%d-%H%M%S')"
PACMAN_CONF_FILES=("/etc/pacman.conf" "/etc/pacman.d/mirrorlist")

# Files related to boot optimization
BOOT_OPTIMIZATION_FILES=(
  "/etc/default/grub"                   # GRUB configuration
  "/etc/mkinitcpio.conf"               # Initramfs hooks
  "/etc/systemd/system.conf"           # systemd timeout settings
  "/etc/systemd/logind.conf"           # Power management
  "/etc/fstab"                         # Filesystem mounts
  "/etc/modprobe.d/"                   # Kernel module blacklists
  "/etc/sysctl.d/"                     # Kernel runtime parameters
  "/boot/loader/entries/"              # systemd-boot entries (if used)
  "/etc/udev/rules.d/"                 # udev rules (for hardware delays)
)

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "📦 Backing up essential .config items..."
tar -czvf "$BACKUP_DIR/my-configs.tar.gz" \
    "$HOME/.zshrc" \
    "$HOME/.bashrc" \
    "$HOME/.config/dconf" \
    "$HOME/.config/gtk-2.0" \
    "$HOME/.config/gtk-3.0" \
    "$HOME/.config/gtk-4.0" \
    "$HOME/.config/systemd" \
    "$HOME/.config/user-dirs.dirs" \
    "$HOME/.config/monitors.xml" \
    2>/dev/null

# Backup GNOME settings (redundant safety)
echo "🖥️  Backing up GNOME settings..."
dconf dump / > "$BACKUP_DIR/gnome-settings.ini"

# Backup package list
echo "📦 Backing up installed packages..."
pacman -Qqe > "$BACKUP_DIR/pkglist.txt"

# Backup Pacman configs automatically
echo "⚙️  Backing up Pacman configs..."
for file in "${PACMAN_CONF_FILES[@]}"; do
    if [ -f "$file" ]; then
        sudo cp -v "$file" "$BACKUP_DIR/"
    fi
done

# Backup boot optimization files
echo "🚀 Backing up boot optimization files..."
for file in "${BOOT_OPTIMIZATION_FILES[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        sudo cp -rv "$file" "$BACKUP_DIR/"
    fi
done

# Backup EFISTUB entry (if used)
if [ -d "/boot/EFI" ]; then
    echo "🔧 Backing up EFI boot entries..."
    sudo efibootmgr -v > "$BACKUP_DIR/efibootmgr.txt"
fi

# Backup kernel parameters (current cmdline)
echo "⚙️  Backing up kernel parameters..."
cat /proc/cmdline > "$BACKUP_DIR/cmdline.txt"

# Ensure the backup directory is owned by the current user
sudo chown -R "$USER":"$USER" "$BACKUP_DIR"

# Final report
echo -e "\n✅ Backup complete!"
echo "📁 Backup directory: $BACKUP_DIR"
echo "💾 Contents:"
ls -lh "$BACKUP_DIR"