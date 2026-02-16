# Ubuntu windows7:
## Desktop icons
```bash
sudo apt update && sudo apt install -y gnome-shell-extension-desktop-icons-ng && gnome-extensions enable ding@rastersoft.com
```
## Dash to panel
```bash
sudo apt install gnome-shell-extension-dash-to-panel
```
```bash
gnome-extensions enable dash-to-panel@jderose9.github.com
```
## Add desktop numbers
```bash
sudo apt install -y gnome-shell-extensions
```
```bash
gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com
```
## Speed up UI animation
```bash
gsettings set org.gnome.desktop.interface enable-animations true
```
## Window snap tiling
```bash
gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false && gsettings set org.gnome.mutter edge-tiling true 
```
```bash
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Super>'
```
## Add maximize minimize buttons
```bash
gsettings set org.gnome.desktop.interface gtk-decoration-layout "appmenu:minimize,maximize,close"
```
## Minimize app when clicked in dock
```bash
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```
## Alt + TAB
```bash
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]" && gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
```
## Dekstop trash generator 9000
```bash
touch ~/Templates/"New Image.png"
```
```bash
touch ~/Templates/"New File.txt"
```
## Rename drawing to paint
```bash
sudo snap install drawing
```
```bash
cp /usr/share/applications/org.gnome.drawing.desktop ~/.local/share/applications/paint.desktop
```
```bash
cat <<EOF > ~/.local/share/applications/paint.desktop
[Desktop Entry]
Name=Paint
Comment=Drawing application for GNOME
Keywords=paint;drawing;windows;ms-paint;image;edit;
Exec=snap run drawing %U
Icon=drawing
Terminal=false
Type=Application
Categories=GNOME;GTK;Graphics;
MimeType=image/png;image/jpeg;image/bmp;
StartupNotify=true
EOF
```

## Rename screenshot Snipping tool
```bash
cp /usr/share/applications/org.gnome.Screenshot.desktop ~/.local/share/applications/snipping-tool.desktop
```
```bash
mkdir -p ~/.local/share/applications/
cat <<EOF > ~/.local/share/applications/snipping-tool.desktop
[Desktop Entry]
Name=Snipping Tool
Comment=Take screenshots and screen recordings
Keywords=snip;snipping;tool;windows;screenshot;capture;
Exec=gnome-screenshot -i
Terminal=false
Type=Application
Icon=org.gnome.Screenshot
Categories=GNOME;GTK;Utility;
StartupNotify=true
EOF
```
## Refresh database
```bash
update-desktop-database ~/.local/share/applications/
```

## Breadcrumbs
```bash
sudo apt install -y zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
```bash
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
```
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
```bash
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
source ~/.zshrc
```

# Install Virtualization for your "User Space" Window
```bash
sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager virt-viewer
```

```bash
sudo usermod -aG libvirt $USER
```

```bash
sudo usermod -aG kvm $USER
```

``` bash
sudo ubuntu-drivers install --gpgpu
```
``` bash
sudo ubuntu-drivers install --gpgpu
```

# Gaming shell

Enable 32-bit architecturefor Steam/Proton
```bash
sudo dpkg --add-architecture i386
```

Install Steam, GameMode (CPU optimization), and MangoHud (monitoring)

```bash
sudo apt install -y steam-installer steam-devices gamemode mangohud
```

Install Hardware Drivers (Proprietary for GPU acceleration)
```bash
sudo ubuntu-drivers install
```


# ZFS limits (run from librarian OS)

Limit ZFS RAM cache (ARC) so Steam/Solvers have room (example: 8GB limit)

```bash
echo "options zfs zfs_arc_max=8589934592" | sudo tee /etc/modprobe.d/zfs.conf
```

Increase file limits for heavy OpenFOAM parallel solves
```bash
echo -e "* soft nofile 524288\n* hard nofile 524288" | sudo tee -a /etc/security/limits.conf
```


