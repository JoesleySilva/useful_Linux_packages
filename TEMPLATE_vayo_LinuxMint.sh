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
sudo mv -v /etc/apt/preferences.d/nosnap.pref /home/p527488/Downloads/
sudo apt install snapd -y

echo 'Instalação do SNAP'
sudo apt install snapd
sudo systemctl enable snapd
sudo systemctl start snapd

echo 'Windows Theme'
wget https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/2025-04-17.tar.gz 
#mkdir Fluent-gtk-theme-2025-04-17 
tar -xzf 2025-04-17.tar.gz
cd 2025-04-17.tar.gz
sudo ./install.sh
gsettings set org.cinnamon.theme name "Fluent"
