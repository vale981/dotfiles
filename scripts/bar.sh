#!/usr/bin/env sh

# Terminate already running bar instances
killall -q yabar

# Wait until the processes have been shut down
while pgrep -u $UID -x yabar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
yabar


echo "Bars launched..."
