#!/usr/bin/env bash

shopt -s nullglob
leds=(/sys/class/leds/*::capslock/brightness)
locked=0

if (( ${#leds[@]} > 0 )); then
  read -r locked < "${leds[0]}"
fi

if [[ "$locked" == 1 ]]; then
  printf '{"text":"󰪛 CAPS","class":"locked"}\n'
else
  printf '{"text":"","class":"unlocked"}\n'
fi
