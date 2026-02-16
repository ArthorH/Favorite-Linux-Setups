#!/bin/bash

# =================================================================
#           UBUNTU WINDOWS 7 RICE - "THE LIBRARIAN"
# =================================================================
# Logging Setup
LOG_FILE="/tmp/librarian_$(date +%Y%m%d_%H%M%S).log"
touch "$LOG_FILE"

exec > >(tee -a "$LOG_FILE") 2>&1 
# Note: The line above sends everything to the console AND the log.
# If you want the console to stay "clean" (stealth mode), 
# we will handle redirection inside the run_task function instead.

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
echo "Detailed logs are being written to: $LOG_FILE"
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
read -p "Select options (e.g., 234 or 1): " choice

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

# Enhanced Logging Task Function
run_task() {
    local task_name=$1
    shift
    echo -ne " [....] $task_name"
    
    # Log the start of the task
    echo "--- STARTING TASK: $task_name ---" >> "$LOG_FILE"
    
    # Execute command, capturing all output to the log file
    if eval "$@" >> "$LOG_FILE" 2>&1; then
        echo -e "\r [\033[0;32m DONE \033[0m] $task_name"
        echo "--- TASK SUCCESS: $task_name ---" >> "$LOG_FILE"
    else
        echo -e "\r [\033[0;31m FAIL \033[0m] $task_name (Check $LOG_FILE)"
        echo "--- TASK FAILED: $task_name ---" >> "$LOG_FILE"
    fi
}

echo -e "\n\033[1;33mStarting Tasks...\033[0m\n"

# 0. Pre-flight
sudo -v

run_task "Installing curl" "sudo apt update && sudo apt install -y curl"

# 1. UI Overhaul
if [ "$INSTALL_UI" = true ]; then
    run_task "Installing Extensions" "sudo apt install -y gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extensions gnome-screenshot"
    run_task "Enabling Win7 Layout" "gnome-extensions enable ding@rastersoft.com && gnome-extensions enable dash-to-panel@jderose9.github.com"
    run_task "Configuring Aero Snap" "gsettings set org.gnome.mutter edge-tiling true && gsettings set org.gnome.desktop.interface gtk-decoration-layout 'appmenu:minimize,maximize,close'"
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
    update-desktop-database ~/.local/share/applications/ >> "$LOG_FILE" 2>&1
fi

# 3. ZSH
if [ "$INSTALL_ZSH" = true ]; then
    run_task "Installing ZSH/Fastfetch" "sudo apt install -y zsh git fastfetch"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        run_task "Installing Oh My Zsh" "curl -fsSL https://raw.githubusercontent.com/oh-my-zsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended"
    fi
    run_task "Adding Plugins & Theme" "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc"
fi

# 4. Power User Features
if [ "$INSTALL_VIRT" = true ]; then
    run_task "Installing Virtualization" "sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager && sudo usermod -aG libvirt,kvm $USER"
fi

if [ "$INSTALL_GAMING" = true ]; then
    run_task "Preparing Gaming Shell" "sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install -y steam-installer gamemode mangohud"
fi

if [ "$INSTALL_LIBRARIAN" = true ]; then
    run_task "Optimizing ZFS/Limits" "echo 'options zfs zfs_arc_max=8589934592' | sudo tee /etc/modprobe.d/zfs.conf && sudo update-initramfs -u"
    run_task "Syncing Clock" "timedatectl set-local-rtc 1 --adjust-system-clock"
fi

echo -e "\n\033[1;32m[SUCCESS]\033[0m Processed selected tasks."
echo "Full log available at: $LOG_FILE"