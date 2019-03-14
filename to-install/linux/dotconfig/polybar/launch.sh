#!/usr/bin/env bash

if pgrep -x polybar ; then
  pkill -x polybar -USR1 &
  exit 0
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=""
# If we're on my Thinkpad, pin Polybar to the builtin display, as opposed to the
# (possibly-connected) "primary monitor"
if [ "$(cat /sys/class/drm/card0/card0-eDP-1/status)" = "connected" ] ; then
  MONITOR="eDP-1"
fi
MONITOR="${MONITOR}" polybar ai &

echo "Bars launched..."
