#!/bin/sh

# Start at 50% brightness
xbacklight -set 50

# source ~/.config/headmicfix.sh

# Right click with 2 fingers instead
xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' 337 0 1
# Increase trackpad sensitivity
# xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' 309 0.2

# Enable tap to click (but not tap to drag)
xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' 326 1
xinput set-prop 'DLL075B:01 06CB:76AF Touchpad' 328 0
