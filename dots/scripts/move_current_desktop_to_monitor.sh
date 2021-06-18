#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
bash move_to_monitor.sh `bspc query -D -d focused --names` $1
