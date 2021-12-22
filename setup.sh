#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Initial Updates"
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

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

echo "Installing Gnmap Parser"
#### Git Gnmap Parser
apt-get install git
mkdir /tools
mkdir /tools/gnmap-parser
git clone https://github.com/jasonjfrank/gnmap-parser.git /tools/gnmap-parser/

echo "Retrieving Burp Install Link"
runuser -u kali firefox https://portswigger.net/burp/releases#professional &
