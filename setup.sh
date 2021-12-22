#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Setting timezone"
timedatectl set-timezone America/Chicago

echo "Disabling Lock Screen"
gsettings set org.gnome.desktop.screensaver lock-enabled false

echo "Initial Updates"
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt -y autoremove
apt -y autoclean
updatedb

vmware-hgfsclient | while read folder; do
	echo "[i] Mounting ${folder}(/mnt/hgfs/${folder})"
	mkdir -p "/mnt/hgfs/${folder}"
	umount -f "/mnt/hgfs/${folder}" 2>/dev/null
	vmhgfs-fuse -o allow_other -o auto_unmount ".host:/${folder}" "/mnt/hgfs/${folder}"
done
sleep 2s

echo "Installing Sublime Text"
#### Install SublimeText
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install sublime-text -y

echo "Installing Linux Utilities"
apt-get install tree -y
apt-get install python3-pip -y
apt-get install feroxbuster -y


echo "Installing Python Utilities"
pip3 install tldr

echo "Installing Gnmap Parser"
#### Git Gnmap Parser
apt-get install git
git clone https://github.com/jasonjfrank/gnmap-parser.git /opt/gnmap-parser/

echo "Installing Discover"
git clone https://github.com/leebaird/discover.git /opt/discover/

echo "Running Discover Update"
/opt/discover/update.sh

echo "Retrieving Burp Install Link"
runuser -u kali firefox https://portswigger.net/burp/releases#professional &
