#!/usr/bin/env bash
spotifyd_stat() {
  meta=$(playerctl metadata -f '{{status}} {{title}} / {{artist}}' -p spotifyd)
  echo "$meta" | sed 's/  */ /g' | sed 's/Playing/♪/g' | sed 's/Paused/⏸/g' | sed 's/Stopped/⏹/g'
}

spotifyd_play_pause() {
  playerctl play-pause -p spotifyd
}

spotifyd_next() {
  playerctl next -p spotifyd
}

spotifyd_previous() {
  playerctl previous -p spotifyd
}

command=$1

case "$command" in
  stat)
    spotifyd_stat
    ;;
  play_pause)
    spotifyd_play_pause
    ;;
  next)
    spotifyd_next
    ;;
  previous)
    spotifyd_previous
    ;;
  *)
    spotifyd_stat
    ;;
esac
