#!/bin/bash

# =================================================================
#           UBUNTU WINDOWS 7 RICE - "THE LIBRARIAN" (v2.1)
# =================================================================
LOG_FILE="/tmp/librarian_$(date +%Y%m%d_%H%M%S).log"
touch "$LOG_FILE"

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
echo -e "Detailed logs: \033[1;32m$LOG_FILE\033[0m"
# =================================================================

# Flags
INSTALL_UI=false; INSTALL_APPS=false; INSTALL_ZSH=false
INSTALL_VIRT=false; INSTALL_GAMING=false; INSTALL_LIBRARIAN=false

echo -e "\n\033[1;34m--- INSTALLATION MENU ---\033[0m"
echo "1) [ALL]   Full Windows 7 Workstation Setup"
echo "2) [UI]    Win7 Layout, Dash-to-Panel, Aero Snap"
echo "3) [APPS]  Paint, Snipping Tool, Desktop Templates"
echo "4) [TERM]  ZSH, Powerlevel10k Breadcrumbs, Plugins"
echo "5) [VIRT]  KVM, Virt-Manager (User Space Windows)"
echo "6) [GAME]  Steam, GameMode, GPU Drivers"
echo "7) [SPEC]  ZFS ARC Limits, OpenFOAM File Limits"
echo "q) [QUIT]  Exit"
echo "-------------------------"
read -p "Select options: " choice

case $choice in
    *1*) INSTALL_UI=true; INSTALL_APPS=true; INSTALL_ZSH=true; INSTALL_VIRT=true; INSTALL_GAMING=true; INSTALL_LIBRARIAN=true ;;
    *2*) INSTALL_UI=true ;;
    *3*) INSTALL_APPS=true ;;
    *4*) INSTALL_ZSH=true ;;
    *5*) INSTALL_VIRT=true ;;
    *6*) INSTALL_GAMING=true ;;
    *7*) INSTALL_LIBRARIAN=true ;;
    *q*) exit 0 ;;
esac

run_task() {
    local task_name=$1
    shift
    echo -ne " [....] $task_name"
    echo "--- STARTING: $task_name ---" >> "$LOG_FILE"
    
    # Use dbus-launch for gsettings/gnome-extensions commands to prevent dconf errors
    if eval "$@" >> "$LOG_FILE" 2>&1; then
        echo -e "\r [\033[0;32m DONE \033[0m] $task_name"
    else
        echo -e "\r [\033[0;31m FAIL \033[0m] $task_name"
    fi
}

echo -e "\n\033[1;33mStarting Tasks...\033[0m\n"

sudo -v

# 0. Dependencies
run_task "Core Tools" "sudo apt update && sudo apt install -y curl dbus-x11 git"

# 1. UI Overhaul
if [ "$INSTALL_UI" = true ]; then
    # Fix: Use the standard extensions pack since specific names vary by Ubuntu version
    run_task "Installing Extensions" "sudo apt install -y gnome-shell-extension-prefs gnome-shell-extension-manager gnome-shell-extensions gnome-screenshot"
    
    # Fix: Use dbus-launch to ensure the script can talk to your session
    run_task "Enabling Win7 Layout" "dbus-launch gnome-extensions enable ding@rastersoft.com && dbus-launch gnome-extensions enable dash-to-panel@jderose9.github.com"
    
    # Fix: Corrected gsettings path for window buttons
    run_task "Configuring Aero Snap" "gsettings set org.gnome.mutter edge-tiling true && gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'"
fi

# 2. Apps
if [ "$INSTALL_APPS" = true ]; then
    run_task "Creating Templates" "mkdir -p ~/Templates && touch ~/Templates/'New Image.png' ~/Templates/'New File.txt'"
    run_task "Installing Paint" "sudo snap install drawing"
    run_task "Mapping Paint/Snip" "cat <<EOF > ~/.local/share/applications/paint.desktop
[Desktop Entry]
Name=Paint
Exec=snap run drawing %U
Icon=drawing
Type=Application
EOF
cat <<EOF > ~/.local/share/applications/snipping-tool.desktop
[Desktop Entry]
Name=Snipping Tool
Exec=gnome-screenshot -i
Icon=org.gnome.Screenshot
Type=Application
EOF"
    update-desktop-database ~/.local/share/applications/
fi

# 3. ZSH
if [ "$INSTALL_ZSH" = true ]; then
    run_task "Installing ZSH" "sudo apt install -y zsh git fastfetch"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        run_task "Oh My Zsh" "curl -fsSL https://raw.githubusercontent.com/oh-my-zsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended"
    fi
    run_task "P10k Theme" "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc"
fi

# 4. Power User Features
if [ "$INSTALL_VIRT" = true ]; then
    run_task "Virtualization" "sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager && sudo usermod -aG libvirt,kvm $USER"
fi

if [ "$INSTALL_GAMING" = true ]; then
    run_task "Gaming Libs" "sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y steam-installer gamemode mangohud"
fi

if [ "$INSTALL_LIBRARIAN" = true ]; then
    run_task "ZFS/Clock Sync" "timedatectl set-local-rtc 1 --adjust-system-clock"
fi

echo -e "\n\033[1;32m[COMPLETE]\033[0m Setup finished."
echo "If UI changes didn't appear, press Alt+F2, type 'r', and hit Enter."