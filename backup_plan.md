### 📥 **Backup Plan**  
*(Run this on your current system)*  

1. **Save Configs & Dotfiles**  
   ```bash  
   tar -czvf ~/my-configs.tar.gz ~/.zshrc ~/.bashrc ~/.config ~/.local
   ```  
   *(This bundles your terminal/config files into `my-configs.tar.gz`)*  

2. **Export GNOME Settings**  
   ```bash  
   dconf dump / > ~/gnome-settings.ini  
   ```  
   *(Saves all GNOME shortcuts, themes, and tweaks)*  

3. **Backup Installed Packages**  
   ```bash  
   pacman -Qqe > ~/pkglist.txt  
   ```  
   *(Lists all explicitly installed apps/packages)*  

4. **Optional: Save Pacman Configs**  
   ```bash  
   sudo cp /etc/pacman.conf /etc/pacman.d/mirrorlist ~/  
   ```  
   *(Backup your package manager settings)*  

---

### 📤 **Restore Plan**  
*(On the new Arch system after installation)*  

1. **Copy Backups**  
   Transfer these files to the new system:  
   - `my-configs.tar.gz`  
   - `gnome-settings.ini`  
   - `pkglist.txt`  
   - (Optional) `pacman.conf`, `mirrorlist`  

2. **Restore Pacman Configs (Optional)**  
   ```bash  
   sudo cp ~/pacman.conf /etc/  
   sudo cp ~/mirrorlist /etc/pacman.d/  
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
