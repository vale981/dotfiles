###############################################################################
#                               External Monitor                              #
###############################################################################
source ~/dotfiles/config.sh

# This script should only run when X is running.
# Exit immediately if X isn't running.
pgrep X > /dev/null || exit 0

all_workspaces="1 2 3 4 5 6 7 8 9 10"
declare -A workspaces

#workspaces[0]="1 5 8"
workspaces[0]="2 4 7 6"
workspaces[1]="3 9 10"

move_to_monitor() {
    for D in $1; do
        bspc desktop $D --to-monitor $2
    done
}

echo bspc query -D --names | rg 1 || bspc monitor $MAIN_MONITOR -d $all_workspaces
if [[ $SIDE_MONITORS != "" ]]; then
    echo "DOCKED"
    eval $SCREEN_LAYOUT_DOCKED
    move_to_monitor "$all_workspaces" $MAIN_MONITOR

    for i in "${!SIDE_MONITORS[@]}"; do
        move_to_monitor "${workspaces[$i]}" "${SIDE_MONITORS[$i]}"
    done
else
    eval $SCREEN_LAYOUT
    move_to_monitor "$all_workspaces" $MAIN_MONITOR
fi

~/.scripts/wallp
sleep 1 && ~/.config/polybar/launch.sh
