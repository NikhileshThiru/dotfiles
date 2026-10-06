#!/bin/sh
logger "kbd hook: $1"
LED=/sys/class/leds/rgb:kbd_backlight
if [ "$1" = "post" ]; then
  sleep 2
  cat $LED/max_brightness > $LED/brightness
  echo "0 200 255" > $LED/multi_intensity
fi
