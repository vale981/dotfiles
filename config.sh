WIFI_DEV="wlp4s0"
ETH_DEV="enp0s31f6"

MAIN_NET=$WIFI_DEV
BATTERIES=(BAT0 BAT1)
zMAIN_FONT="Source Code Pro 8"
SCREEN_LAYOUT="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --off --output DP-2-2 --off --output DP-2-3 --off"
SCREEN_LAYOUT_DOCKED="xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output DP-2-2 --mode 1920x1200 --pos 4480x0 --rotate normal --output DP-2-3 --mode 1920x1080 --pos 0x0 --rotate normal"
#SCREEN_LAYOUT_DOCKED="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --mode 1920x1080 --pos 1920x0 --rotate normal"
MONITORS=(DP-2-1 DP-2-3 DP-2-2)
#MONITORS=(eDP-1 HDMI-2)
MAIN_MONITOR=DP-2-1
#MAIN_MONITOR=eDP-1
SIDE_MONITORS=($(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1 | grep -v $MAIN_MONITOR))
BAR_POS="top"
LAPTOP=1
TERM_FONT_SIZE=6
