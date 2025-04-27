### 📤 **Restore Plan**  
*(On the new Arch system after installation)*  

1. **Copy Backups**  
   Transfer these files to the new system:  
   - `my-configs.tar.gz`  
   - `gnome-settings.ini`  
   - `pkglist.txt`  
   - `pacman.conf`, `mirrorlist`
   - `boot-optimizations/`

2. **Restore Pacman Configs**  
   ```bash  
   sudo cp pacman.conf /etc/  
   sudo cp mirrorlist /etc/pacman.d/  
   sudo pacman -Syu  
   ```  

3. **Install Packages**  
   ```bash  
   sudo pacman -S - < ~/pkglist.txt  
   ```  
   *(For AUR packages, use `yay -S - < ~/pkglist.txt`)*  

4. **Restore Configs & Dotfiles**  
   ```bash  
   tar -xzvf ~/my-configs.tar.gz -C ~/  
   ```  

5. **Apply GNOME Settings**  
   ```bash  
   dconf load / < ~/gnome-settings.ini  
   ```

6. **Restore Boot Optimizations**
   ```bash
   # Rebuild GRUB  
   sudo cp boot-optimizations/grub /etc/default/  
   sudo grub-mkconfig -o /boot/grub/grub.cfg  

   # Rebuild initramfs  
   sudo cp boot-optimizations/mkinitcpio.conf /etc/  
   sudo mkinitcpio -P  

   # Apply systemd tweaks  
   sudo cp boot-optimizations/system.conf /etc/systemd/  
   sudo systemctl daemon-reload  
   ```

7. **Verify**
   ```bash
   systemd-analyze time  # Check boot time  
   cat /proc/cmdline     # Confirm "loglevel=0 quiet"  
   systemctl start docker ollama  # Test optional services  
   ```