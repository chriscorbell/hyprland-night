#!/bin/bash

clear

echo -e "${MAGENTA}"
cat << "EOF"

      .__                        .__                     .___      
      |  |__ ___.__._____________|  | _____    ____    __| _/      
      |  |  <   |  |\____ \_  __ \  | \__  \  /    \  / __ |       
      |   Y  \___  ||  |_> >  | \/  |__/ __ \|   |  \/ /_/ |       
      |___|  / ____||   __/|__|  |____(____  /___|  /\____ |       
           \/\/     |__|                   \/     \/      \/       
                          .__       .__     __   
                     ____ |__| ____ |  |___/  |_ 
                    /    \|  |/ ___\|  |  \   __\
                   |   |  \  / /_/  >   Y  \  |  
                   |___|  /__\___  /|___|  /__|  
                        \/  /_____/      \/

EOF
echo -e "${NOCOLOR}"

sleep 5

sudo pacman -S --needed --noconfirm jq socat git base-devel bluez bluez-libs bluez-utils pipewire pipewire-pulse wireplumber cava swayimg dunst hyprland hyprlock hyprpicker hyprpolkitagent swww nautilus wofi grim slurp wl-clipboard wl-clip-persist xdg-desktop-portal xdg-desktop-portal-hyprland xorg-xwayland inter-font kitty nwg-look openssh sassc ttf-jetbrains-mono-nerd visual-studio-code-bin playerctl waybar

# Clone the repo to a temporary directory
TEMP_DIR=$(mktemp -d)
if git clone https://github.com/chriscorbell/hyprland-night "$TEMP_DIR"; then
        # Copy dotfiles to home directory
        cp -r "$TEMP_DIR"/.config "$HOME/"
        cp -r "$TEMP_DIR"/walls "$HOME/"
        # Clean up temp directory
        rm -rf "$TEMP_DIR"
        
        # Create VS Code settings
        code --install-extension fabiospampinato.vscode-monokai-night
        mkdir -p "$HOME/.config/Code/User"
        cat > "$HOME/.config/Code/User/settings.json" << 'EOF'
{
    "editor.minimap.enabled": false,
    "editor.fontFamily": "'JetBrainsMono Nerd Font'",
    "editor.stickyScroll.enabled": false,
    "window.menuBarVisibility": "compact",
    "breadcrumbs.enabled": false,
    "workbench.colorTheme": "Monokai Night"
}
EOF
        
        echo -e "\n\e[32mDotfiles installed successfully!\e[0m\n"
    
    # Install GTK theme and icons
    echo -e "\n\e[32mInstalling GTK theme and icons...\e[0m\n"
    THEME_DIR=$(mktemp -d)
    if git clone https://github.com/vinceliuice/Fluent-gtk-theme "$THEME_DIR/Fluent-gtk-theme"; then
        # Install GTK theme
        cd "$THEME_DIR/Fluent-gtk-theme"
        chmod +x install.sh
        ./install.sh -t all -c dark -s compact -l --tweaks solid
        cd -
        
        # Install icons
        git clone https://github.com/vinceliuice/Fluent-icon-theme "$THEME_DIR/Fluent-icon-theme"
        cd "$THEME_DIR/Fluent-icon-theme"
        chmod +x install.sh
        ./install.sh -a
        cd -
        
        # Clean up
        rm -rf "$THEME_DIR"
        echo -e "\n\e[32mGTK theme and icons installed successfully!\e[0m\n"
    else
        echo -e "\n\e[31mError: Failed to clone GTK and icon theme repositories\e[0m\n"
        rm -rf "$THEME_DIR"
    fi
    
    mkdir -p "$HOME/Screenshots"

else
    echo -e "\n\e[31mError: Failed to clone dotfiles repository\e[0m\n"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo
echo -e "\n\e[32m=== Installation complete!\e[0m\n"

echo -e "\e[31m=== It is recommended to reboot your system to apply all changes\e[0m\n"
