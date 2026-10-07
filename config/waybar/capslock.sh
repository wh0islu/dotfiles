#!/usr/bin/env bash
# Persistent waybar module: keep running and print only when Caps Lock changes,
# so waybar does not need to repeat fork/parse/redraw on each tick.

shopt -s nullglob
leds=(/sys/class/leds/*::capslock/brightness)

if (( ${#leds[@]} == 0 )); then
  printf '{"text":"","class":"unlocked"}\n'
  exec sleep infinity
fi

led="${leds[0]}"
previous=""

while :; do
  read -r state < "$led"
  if [[ "$state" != "$previous" ]]; then
    previous="$state"
    if [[ "$state" == 1 ]]; then
      printf '{"text":"󰪛 CAPS","class":"locked"}\n'
    else
      printf '{"text":"","class":"unlocked"}\n'
    fi
  fi
  sleep 0.15
done
