WIFI_DEV="wlp4s0"
ETH_DEV="enp0s31f6"

MAIN_NET=$WIFI_DEV
BATTERIES=(BAT0 BAT1)
MAIN_FONT="Source Code Pro 8"
SCREEN_LAYOUT="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --off --output DP-2-2 --off --output DP-2-3 --off"
SCREEN_LAYOUT_DOCKED="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-2-2 --mode 1280x1024 --pos 3840x0 --rotate normal --output DP-2-3 --off"
MONITORS=(eDP-1 DP-2-2 DP-2-1)
MAIN_MONITOR=eDP-1
SIDE_MONITORS=($(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1 | grep -v $MAIN_MONITOR))
BAR_POS="top"
LAPTOP=1
TERM_FONT_SIZE=6
