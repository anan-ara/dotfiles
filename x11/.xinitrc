[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

source ~/.config/startup/xps.sh
source ~/.config/startup/remaps.sh

/* exec bspwm */
exec awesome
