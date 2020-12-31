#!/bin/sh
polybar-msg cmd quit
polybar main & disown
polybar ext & disown
xdo id -m -N Polybar && polybar-msg cmd hide
