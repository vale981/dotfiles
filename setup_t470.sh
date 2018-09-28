#!/bin/bash
# Requirement: User + Sudo

# Packages
TEMP=$(mktemp -d)
cd TEMP
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -Syu
yay -S $(cat t470/pkgs)


# Powersaving
sudo powertop --calibrate

sudo cp t470/tlp > /etc/default/tlp

sudo cat <<EOF > /etc/systemd/system/powertop.service
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable powertop
sudo systemctl enable tlp.service  
sudo systemctl enable tlp-sleep.service

