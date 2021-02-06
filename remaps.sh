#!/bin/sh

# This script is called on startup to remap keys.
# Increase key speed via a rate change
xset r rate 200 50

# Map the caps lock key to ctrl
setxkbmap -option caps:ctrl_modifier
# setxkbmap -option caps:super

# Switch left super and left alt
setxkbmap -option altwin:swap_lalt_lwin

# But when it is pressed only once, treat it as escape.
killall xcape 2>/dev/null ; xcape -e 'Caps_Lock=Escape'

# For the full HHKB experience
xmodmap -e 'keycode 22 = backslash bar'
xmodmap -e 'keycode 51 = BackSpace'
