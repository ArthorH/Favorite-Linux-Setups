# Ubuntu windows7:
## Desktop icons
```bash
sudo apt update && sudo apt install -y gnome-shell-extension-desktop-icons-ng && gnome-extensions enable ding@rastersoft.com
```

## Dekstop trash generator 9000
```bash
touch ~/Templates/"New Image.png"
```
```bash
touch ~/Templates/"New File.txt"
```
## Rename drawing to paint
Install
```bash
sudo snap install drawing
```
 Rename to paint
```bash
cp /usr/share/applications/org.gnome.drawing.desktop ~/.local/share/applications/paint.desktop
```
Search entries
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

## Snipping tool
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

## 

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

