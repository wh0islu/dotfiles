#!/usr/bin/env bash

set -euo pipefail

config_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
profile="${1:-auto}"

if [[ "$profile" == "auto" ]]; then
    chassis_type=""
    if [[ -r /sys/class/dmi/id/chassis_type ]]; then
        IFS= read -r chassis_type < /sys/class/dmi/id/chassis_type || true
    fi

    case "$chassis_type" in
        8|9|10|11|14|30|31|32)
            profile="laptop"
            ;;
        3|4|5|6|7|13|15|16)
            profile="desktop"
            ;;
        *)
            shopt -s nullglob
            batteries=(/sys/class/power_supply/BAT*)
            if ((${#batteries[@]})); then
                profile="laptop"
            else
                profile="desktop"
            fi
            ;;
    esac
fi

case "$profile" in
    desktop)
        config_file="$config_dir/desktop/config.ini"
        ;;
    laptop)
        config_file="$config_dir/laptop/config.ini"
        ;;
    *)
        echo "Usage: $0 [auto|desktop|laptop]" >&2
        exit 2
        ;;
esac

if [[ ! -r "$config_file" ]]; then
    echo "Polybar config not found: $config_file" >&2
    exit 1
fi

polybar-msg cmd quit >/dev/null 2>&1 || true
polybar --config="$config_file" example &
