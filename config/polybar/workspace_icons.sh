#!/bin/bash

current_ws=$(($(xdotool get_desktop) + 1))
windows=$(wmctrl -lx | awk -v ws="$(xdotool get_desktop)" '$2 == ws {print $3}' | cut -d'.' -f2)

get_icon() {
    case "$1" in
        firefox) echo " " ;;
        code) echo " " ;;
        gimp) echo " " ;;
        spotify|Spotify) echo " " ;;
        terminal|alacritty|Alacritty|xterm) echo "" ;;
        *) echo "" ;;
    esac
}

output="$current_ws -"
for window in $windows; do
    icon=$(get_icon "$window")
    output+=" $icon"
done

echo "$output"
