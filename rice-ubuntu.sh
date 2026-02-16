#!/bin/bash
clear
cat << "EOF"
          _nnnn_
         dGGGGMMb
        @p~qp~~qMb
        M|@||@) M|
        @,----.JM|
       JS^\__/  qKL
      dZP         qKRb
     dZP           qKKb
    fZP             SMMb
    HZM             MMMM
    FqM             MMMM
  __| ".         |\dS"qML
  |    `.       | `' \Zq
 _)      \.___.,|     .'
\____    )MMMMMP|   .'
      `-'       `--' hjm
EOF
#!/bin/bash

# 1. SETUP LOGGING & ENVIRONMENT
LOG="/tmp/rice.log"
exec > >(tee -a "$LOG") 2>&1
echo "--- Starting Windows 7 Librarian Rice: $(date) ---"

# This allows the script to talk to your UI even if run from a weird terminal
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# 2. CORE TOOLS
echo "[1/6] Installing Core Tools..."
sudo apt update
sudo apt install -y curl git dbus-x11 gnome-shell-extension-manager gnome-shell-extensions gnome-screenshot zsh

# 3. THE UI FIX (Windows 7 Look)
echo "[2/6] Applying Win7 UI Tweaks..."
# Enable minimize/maximize buttons
gsettings set org.gnome.desktop.interface gtk-decoration-layout "appmenu:minimize,maximize,close"
# Snap tiling and animations
gsettings set org.gnome.mutter edge-tiling true
gsettings set org.gnome.desktop.interface enable-animations true
# Alt+Tab fix (Switch windows, not apps)
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"

# 4. APPS & TEMPLATES (Paint & Snipping Tool)
echo "[3/6] Configuring Apps..."
sudo snap install drawing
mkdir -p ~/.local/share/applications/
mkdir -p ~/Templates
touch ~/Templates/"New Image.png" ~/Templates/"New File.txt"

# Create Paint Shortcut
cat <<EOF > ~/.local/share/applications/paint.desktop
[Desktop Entry]
Name=Paint
Exec=snap run drawing %U
Icon=drawing
Type=Application
EOF

# Create Snipping Tool Shortcut
cat <<EOF > ~/.local/share/applications/snipping-tool.desktop
[Desktop Entry]
Name=Snipping Tool
Exec=gnome-screenshot -i
Icon=org.gnome.Screenshot
Type=Application
EOF

update-desktop-database ~/.local/share/applications/

# 5. TERMINAL (ZSH & Powerlevel10k)
echo "[4/6] Setting up Terminal..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# P10k Theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || true
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 6. VIRTUALIZATION & GAMING
echo "[5/6] Final Power User Tweaks..."
sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager steam-installer gamemode mangohud
sudo usermod -aG libvirt,kvm $USER

# 7. THE "MASTER SWITCH"
echo "[6/6] Forcing Extension Master Switch..."
gsettings set org.gnome.shell disable-user-extensions false

echo "------------------------------------------------"
echo "DONE! IMPORTANT NEXT STEPS:"
echo "1. Open 'Extension Manager' app."
echo "2. Search & Install 'Dash to Panel'."
echo "3. REBOOT your computer."
echo "Full log saved to: $LOG"