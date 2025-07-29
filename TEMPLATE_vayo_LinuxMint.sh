#!/bin/bash
# Script para desinstalar pacotes do Linux Mint utilizando o boot do Linux Mint 
sudo apt install terminator flameshot filezilla language-pack-pt language-pack-pt-base -y
sudo setxkbmap -layout br
sudo flatpak install notepadqq com.gigitux.youp -y 
echo 'uninstall Transmission '
sudo apt autoremove transmission-common -y
echo 'uninstall Matri Online Chat '
sudo apt purge mintchat -ysudo flatpak install com.brave.Browser -y
sudo apt purge webapp-manager -y && sudo apt autoremove -y


echo 'Install GTK Theme'
#sudo apt update
sudo apt install git curl wget unzip gnome-tweaks gtk2-engines-murrine gtk2-engines-pixbuf

# Download WhiteSur theme (Windows 11-like)
cd ~/Downloads
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -l -c Dark # Install with light version and dark variant

# Set GTK theme
gsettings set org.cinnamon.desktop.interface gtk-theme "WhiteSur-Dark"


echo 'Configure Taskbar/Panel'

sudo apt install plank
# Start plank
plank &

# Make it autostart
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/plank.desktop << EOF
[Desktop Entry]
Type=Application
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank
Comment=Plank Dock
EOF
sudo timedatectl set-timezone America/Sao_Paulo
