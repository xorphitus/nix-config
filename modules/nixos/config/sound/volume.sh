#!/usr/bin/env bash

DEGREE=1

toggle() {
  wpctl set-mute @DEFAULT_SINK@ toggle
}

up() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%+"
}

down() {
  wpctl set-volume @DEFAULT_SINK@ "${DEGREE}%-"
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
