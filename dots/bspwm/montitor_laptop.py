import os

all_workspaces = set(range(1, 11))

# generically on main
on_main = {1, 5, 6}
rest = all_workspaces - on_main

workspace_distribution = {
    1: [all_workspaces],
    2: [on_main, rest],
    3: [on_main, {2, 4, 9}, rest - {2, 4, 9}],
}

os.system("autorandr --change")


main_monitor = os.popen("bspc query -M -m primary").read().strip()
monitors = os.popen("bspc query -M").readlines()

monitors = map(lambda mon: mon.strip(), monitors)
monitors = filter(lambda mon: mon != main_monitor, monitors)
monitors = [main_monitor] + list(monitors)
monitor_names = {
    id: os.popen(f"bspc query -M -m {id} --names").read().strip() for id in monitors
}

active_mons = [
    l.strip()
    for l in os.popen(
        "xrandr | awk '/ connected/ && /[[:digit:]]x[[:digit:]].*+/{print $1}' "
    )
    .read()
    .splitlines()
]

monitors = list(filter(lambda mon: monitor_names[mon] in active_mons, monitors))
num_mon = len(monitors)

os.system(f"bspc monitor -d {' '.join(str(ws) for ws in all_workspaces)}")

workspace_mapping = []
if num_mon in workspace_distribution:
    workspace_mapping = workspace_distribution[num_mon]
else:
    workspace_mapping = [on_main] + list(map(lambda _: set(), monitors[1:]))

    for i, ws in enumerate(rest):
        workspace_mapping[i % (num_mon - 1) + 1].add(ws)


def ws_to_monitor(ws, monitor):
    os.system(f"bspc desktop {ws} -m {monitor}")


for monitor, ws_set in zip(monitors, workspace_mapping):
    for ws in ws_set:
        ws_to_monitor(ws, monitor)

for ws in os.popen("bspc query -D").readlines():
    name = os.popen(f"bspc query -D -d {ws.strip()} --names").read().strip()
    if not name.isnumeric():
        print(f"Removing weird desktop {name}.")
        children = os.popen(f"bspc query -N -d {ws.strip()}").readlines()
        for child in children:
            os.system(f"bspc node {child} -d 1")

        os.system(f"bspc desktop {ws.strip()} -r")


os.system("bspc wm -o")

os.system("~/.scripts/wallp")
# os.system("sleep 1 && ~/.config/polybar/launch.sh")

current_config = os.popen("autorandr --detect").read().strip()

if current_config == "docked":
    os.system("setxkbmap us")

if current_config == "mobile":
    os.system("setxkbmap us -v workman")
    os.system("xmodmap ~/.xmodmaprc")
