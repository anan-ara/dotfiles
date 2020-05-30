[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

$HOME/.config/remaps.sh

xbacklight -set 50

exec bspwm
