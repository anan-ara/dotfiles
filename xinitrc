[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

exec bspwm
