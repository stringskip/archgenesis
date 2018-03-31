#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /home/genesis/
chown genesis:users /home/genesis -R
chmod 700 /root
cd /usr/bin
ln -sf xfce4-terminal xterm
cd ~/

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

## Uncomment to allow members of group wheel to execute any command
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
## 'Same thing without a password (not secure)'
sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers
## Uncomment to allow members of group sudo to execute any command
sed -i '/%sudo   ALL=(ALL) ALL/s/^#//' /etc/sudoers

groupadd -r autologin
gpasswd -a genesis autologin
groupadd -r nopasswdlogin
gpasswd -a genesis nopasswdlogin

sed -i '$a NoDisplay=true' /usr/share/applications/electron.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/avahi-discover.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/bssh.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/bvnc.desktop 
sed -i '$a NoDisplay=true' /usr/share/applications/qv4l2.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/assistant-qt4.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/designer-qt4.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/linguist-qt4.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/qdbusviewer-qt4.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/xterm.desktop
sed -i '$a NoDisplay=true' /usr/share/applications/uxterm.desktop

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target
systemctl enable graphical.target
systemctl enable lightdm.service
systemctl enable dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
