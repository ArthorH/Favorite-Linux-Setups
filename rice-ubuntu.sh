#!/bin/bash

# =================================================================
#             UBUNTU WINDOWS 7 RICE - "THE LIBRARIAN"
# =================================================================
cat << "EOF"
          _nnnn_
        dGGGGMMb
       @p~qp~~qMb
       M|@||@) M|
       @,----.JM|
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMP|   .'
     `-'       `--' hjm
EOF
# =================================================================

# Stealth Progress Function
run_task() {
    local task_name=$1
    shift
    echo -ne " [....] $task_name"
    if "$@" > /dev/null 2>&1; then
        echo -ne "\r [\033[0;32m DONE \033[0m] $task_name\n"
    else
        echo -ne "\r [\033[0;31m FAIL \033[0m] $task_name\n"
    fi
}

# 0. Pre-flight Check (The "curl" fix)
run_task "Installing curl & Prerequisite tools" sudo apt update && sudo apt install -y curl

# 1. Extensions & UI Overhaul
run_task "Installing GNOME Extensions" sudo apt install -y gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extensions gnome-screenshot
run_task "Enabling Windows Layout" bash -c "gnome-extensions enable ding@rastersoft.com && gnome-extensions enable dash-to-panel@jderose9.github.com && gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com"
run_task "Setting Aero Snap & Buttons" bash -c "gsettings set org.gnome.mutter edge-tiling true && gsettings set org.gnome.desktop.interface gtk-decoration-layout 'appmenu:minimize,maximize,close' && gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'"
run_task "Fixing Alt+Tab Behavior" bash -c "gsettings set org.gnome.desktop.wm.keybindings switch-applications '[]' && gsettings set org.gnome.desktop.wm.keybindings switch-windows \"['<Alt>Tab']\""

# 2. Templates & App Renaming
run_task "Generating Desktop Templates" bash -c "mkdir -p ~/Templates && touch ~/Templates/'New Image.png' ~/Templates/'New File.txt'"
run_task "Installing Paint (Drawing)" sudo snap install drawing
run_task "Creating Search Shortcuts" bash -c 'cat <<EOF > ~/.local/share/applications/paint.desktop
[Desktop Entry]
Name=Paint
Exec=snap run drawing %U
Icon=drawing
Type=Application
Keywords=paint;drawing;windows;
EOF'
run_task "Creating Snipping Tool" bash -c 'cat <<EOF > ~/.local/share/applications/snipping-tool.desktop
[Desktop Entry]
Name=Snipping Tool
Exec=gnome-screenshot -i
Icon=org.gnome.Screenshot
Type=Application
Keywords=snip;windows;
EOF'
run_task "Refreshing Desktop DB" update-desktop-database ~/.local/share/applications/

# 3. Terminal Breadcrumbs
run_task "Installing Terminal Tools" sudo apt install -y zsh git fastfetch
run_task "Installing Oh My Zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
run_task "Downloading ZSH Themes/Plugins" bash -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
run_task "Configuring ZSH Theme" bash -c "sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc"

# 4. Power User: Virt, Gaming, ZFS
run_task "Installing Virtualization" sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager virt-viewer && sudo usermod -aG libvirt,kvm $USER
run_task "Preparing Gaming Shell" sudo dpkg --add-architecture i386 && sudo apt install -y steam-installer steam-devices gamemode mangohud
run_task "Installing Hardware Drivers" sudo ubuntu-drivers install --gpgpu && sudo ubuntu-drivers install
run_task "Optimizing ZFS ARC" bash -c 'echo "options zfs zfs_arc_max=8589934592" | sudo tee /etc/modprobe.d/zfs.conf && sudo update-initramfs -u'
run_task "Setting Parallel Solve Limits" bash -c 'echo -e "* soft nofile 524288\n* hard nofile 524288" | sudo tee -a /etc/security/limits.conf'
run_task "Syncing Dual-Boot Clock" timedatectl set-local-rtc 1 --adjust-system-clock

echo -e "\n\033[1;32m[SUCCESS]\033[0m Setup finished. Please log out and back in to see the changes."