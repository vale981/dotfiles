./monitor_laptop.sh
setxkbmap -device `xinput | rg -i "Kyria Keyboard\\s\\s" | cut -d'=' -f2 | cut -f1` en_US -option ctrl:nocaps
