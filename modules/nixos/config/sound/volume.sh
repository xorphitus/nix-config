#!/usr/bin/env bash

# JBL Pebbles cannot make sound when the volume is less than 87%
MIN_VOLUME=0.87

DEGREE=1

toggle() {
  wpctl set-mute @DEFAULT_SINK@ toggle
}

up() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%+"
}

down() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%-"
  ensure_min
}

ensure_min() {
  vol=$(wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f 2)
  awk -v v="${vol}" -v t="${MIN_VOLUME}" 'BEGIN { exit !(v < t) }'
  if [[ $? -eq 0 ]]; then
    wpctl set-volume @DEFAULT_SINK@ "${MIN_VOLUME}"
  fi
}

case $1 in
  "toggle")
    toggle;;
  "down")
    down;;
  "up")
    up;;
  *)
    exit 1
esac
