#!/bin/bash
# Script para desinstalar pacotes do Linux Mint utilizando o boot do Linux Mint 
sudo apt install flameshot terminator filezilla language-pack-pt language-pack-pt-base -y
sudo setxkbmap -layout br
sudo flatpak install notepadqq com.gigitux.youp com.microsoft.EdgeDev -y
echo 'uninstall Transmission '
sudo apt autoremove transmission-common -y
echo 'uninstall Matri Online Chat '
sudo apt purge mintchat -ysudo flatpak install com.brave.Browser -y
sudo apt purge webapp-manager -y && sudo apt autoremove -y

