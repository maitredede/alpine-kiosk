#!/bin/ash

set -euo pipefail

START_URL="https://www.youtube.com/watch?v=FkZl6wVjpDg"

xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don't blank the video device

bspwm &

midori -e FullScreen -a ${START_URL}
