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
echo -e "Detailed logs: \033[1;32m$LOG_FILE\033[0m"

# =================================================================
#           UBUNTU WINDOWS 7 RICE - "THE LIBRARIAN" (v3.0)
# =================================================================
LOG_FILE="/tmp/librarian_$(date +%Y%m%d_%H%M%S).log"

# Ensure we have the right environment for GNOME commands
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

clear
echo "Logging to: $LOG_FILE"

# 1. MENU
echo -e "1) ALL\n2) UI\n3) APPS\n4) ZSH\n5) VIRT\n6) GAME\n7) SPEC\nq) QUIT"
read -p "Selection: " choice

[[ "$choice" == "q" ]] && exit 0

# 2. THE RELIABLE RUNNER
run_task() {
    echo -n " [....] $1"
    # Log the command for debugging
    echo "--- TASK: $1 ---" >> "$LOG_FILE"
    
    # Execute and capture EVERYTHING to log
    if eval "${@:2}" >> "$LOG_FILE" 2>&1; then
        echo -e "\r [\033[0;32m DONE \033[0m] $1"
    else
        echo -e "\r [\033[0;31m FAIL \033[0m] $1 (See log)"
    fi
}

# 0. PRE-FLIGHT
sudo -v
run_task "System Update" "sudo apt update"

# 1. UI (The "Reliable" Way)
if [[ $choice == *1* || $choice == *2* ]]; then
    run_task "Install UI Tools" "sudo DEBIAN_FRONTEND=noninteractive apt install -y gnome-shell-extension-manager gnome-shell-extensions gnome-screenshot"
    
    # Force Master Extension Switch ON
    run_task "Master Switch" "gsettings set org.gnome.shell disable-user-extensions false"
    
    # Apply Aero Window Buttons
    run_task "Win7 Buttons" "gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'"
    
    # Try enabling extensions (Will fail if not downloaded yet, which is expected on Noble)
    run_task "Enable DING" "gnome-extensions enable ding@rastersoft.com"
fi

# 2. APPS
if [[ $choice == *1* || $choice == *3* ]]; then
    run_task "Templates" "mkdir -p ~/Templates && touch ~/Templates/'New Text.txt'"
    run_task "Install Paint" "sudo snap install drawing"
fi

# 3. ZSH
if [[ $choice == *1* || $choice == *4* ]]; then
    run_task "Install ZSH" "sudo apt install -y zsh git"
    [ ! -d "$HOME/.oh-my-zsh" ] && run_task "OhMyZsh" "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended"
fi

# 4. LIB/POWER USER
if [[ $choice == *1* || $choice == *7* ]]; then
    run_task "RTC Clock" "timedatectl set-local-rtc 1"
fi

echo -e "\n\033[1;33m!!! CRITICAL FINAL STEP !!!\033[0m"
echo "1. Open 'Extension Manager' (search in your apps)."
echo "2. Click 'Browse' -> Search 'Dash to Panel' -> Install."
echo "3. Log out and Log back in."