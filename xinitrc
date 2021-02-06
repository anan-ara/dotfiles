[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

source ~/.config/xps.sh
source ~/.config/remaps.sh

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

exec bspwm
