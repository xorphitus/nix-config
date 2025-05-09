#!/usr/bin/env bash

# JBL Pebbles cannot make sound when the volume is less than 87%, and somehow
# 87% seems not be able to let the both left and right speakers work appropriately.
# Therefore, 88% may be the best as the minimum volume.
MIN_VOLUME_PERCENT=88

DEGREE=2

toggle() {
  wpctl set-mute @DEFAULT_SINK@ toggle
  notify-send -u low ' / 🔇'
}

up() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%+"
  notify-send -u low '🔊'
}

down() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%-"
  ensure_min
  notify-send -u low '🔉' # '🔈'
}

ensure_min() {
  for sink in $(sinks); do
    vol=$(get_current_volume_percent "$sink")

    if [[ "$vol" =~ ^[0-9]+$ ]] && [ "$vol" -lt "$MIN_VOLUME_PERCENT" ]; then
      ctl "${MIN_VOLUME_PERCENT}%"
    fi
  done
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
