# The Minimal KDE Shell

Update

```bash
sudo apt update && sudo apt upgrade -y
```
Install the core desktop shell

``` bash
sudo apt install -y --no-install-recommends \
    plasma-desktop sddm konsole dolphin \
    pavucontrol-qt ark breeze-cursor-theme \
    xserver-xorg-video-all
```

Install Virtualization for your "User Space" Window
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
