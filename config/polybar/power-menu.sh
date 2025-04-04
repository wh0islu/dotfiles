#!/bin/bash

choice=$(echo -e "⏻ Poweroff\n Reboot\n󰒲 Hibernate\n❌Cancel" | rofi -dmenu -p "Power Menu")

case "$choice" in
    "⏻ Poweroff") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    "󰒲 Hibernate") systemctl hibernate ;;
    *) exit 0 ;;
esac
