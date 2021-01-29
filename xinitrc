[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

exec bspwm
