###############################################################################
#                               External Monitor                              #
###############################################################################

workspaces=(I II III V VI VIII IX X IV VII)
mon_1=(I II III V VI VIII IX X)
mon_2=(IV VII)

bspc monitor eDP-1 -d ${workspaces[*]}

MONITOR=$(xrandr | rg -i "\sconnected" | rg -v eDP | cut -d" " -f1)

# move_to_monitor() {
#     local -n workspaces=$1
#     for D in "${workspaces[@]}"; do
#         bspc desktop $D --to-monitor $2
#     done
# }

if [ -n "$MONITOR" ]; then
    bspc monitor HDMI-2 -d IV VII

    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080\
           --rotate normal --output DP-1 --off --output HDMI-2 --off\
           --output DP-2 --off --output $MONITOR --mode 1920x1080i --pos 0x0\
           --rotate normal

    # move_to_monitor $mon_1 $MONITOR
fi
