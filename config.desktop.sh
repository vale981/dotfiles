WIFI_DEV=
ETH_DEV="enp3s0"

MAIN_NET=$ETH_DEV
MAIN_FONT="Source Code Pro 12"
MONITORS=($(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1))
MAIN_MONITOR=${MONITORS[2]}
SIDE_MONITORS=($(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1 | grep -v $MAIN_MONITOR))
RYGEL="true"
BAR_POS="bottom"
DPI=157
TERM_FONT_SIZE=12
SCREENLAYOUT="~/.screenlayout/desktop.sh"
