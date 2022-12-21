WIFI_DEV="wlp0s20f3"
ETH_DEV="enp0s31f6"

MAIN_NET=$WIFI_DEV
BATTERIES=(BAT0)
MAIN_FONT="Source Code Pro 8"
MAIN_MONITOR=eDP-1
SIDE_MONITORS=($(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1 | grep -v $MAIN_MONITOR))
BAR_POS="top"
LAPTOP=1
TERM_FONT_SIZE=10
DPI=169
