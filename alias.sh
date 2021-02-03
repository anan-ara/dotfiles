#!/bin/sh

# Use neovim for vim if present.
command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d"

# easily access files
alias vimrc="vim ~/.config/vimrc"
alias nvimrc="vim ~/.config/nvim/init.vim"
alias zshrc="vim ~/.config/zshrc"
alias tmuxconf="vim ~/.config/tmux/tmux.conf"
alias aliases="vim ~/.config/alias.sh"
alias sxhkdrc="vim ~/.config/sxhkd/sxhkdrc"
alias bspwmrc="vim ~/.config/bspwm/bspwmrc"

# stop weird alacritty incompatibilities when using ssh
alias ssh='TERM=xterm-color ssh'

# fast startx
alias x="startx"


# Verbosity and settings that you pretty much just always are going to want.
alias \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -vI" \
	mkd="mkdir -pv" \
	yt="youtube-dl --add-metadata -i" \
	yta="yt -x -f bestaudio/best" \
	ffmpeg="ffmpeg -hide_banner"

# Colorize commands when possible.
alias \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi"

# These common commands are just too long! Abbreviate them.
alias \
	ka="killall" \
	g="git" \
	trem="transmission-remote" \
	YT="youtube-viewer" \
	sdn="sudo shutdown -h now" \
	f="$FILE" \
	e="$EDITOR" \
	v="$EDITOR" \
	p="sudo pacman" \
	xi="sudo xbps-install" \
	xr="sudo xbps-remove -R" \
	xq="xbps-query" \

