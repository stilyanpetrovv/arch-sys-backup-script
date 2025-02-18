#!/bin/bash

# Configuration
BACKUP_DIR="$HOME/Documents/backup-arch/backup-$(date +'%Y%m%d-%H%M%S')"
PACMAN_CONF_FILES=("/etc/pacman.conf" "/etc/pacman.d/mirrorlist")

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

# Ensure the backup directory is owned by the current user
sudo chown -R "$USER":"$USER" "$BACKUP_DIR"

# Final report
echo -e "\n✅ Backup complete!"
echo "📁 Backup directory: $BACKUP_DIR"
echo "💾 Contents:"
ls -lh "$BACKUP_DIR"
