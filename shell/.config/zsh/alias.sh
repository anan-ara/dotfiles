#!/bin/sh

# Use neovim for vim if present.
# command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d"

# easily access files
alias vimrc="nvim ~/.config/vimrc"
alias nvimrc="nvim ~/.config/nvim/init.vim"
alias zshrc="nvim ~/.config/zsh/.zshrc"
alias tmuxconf="nvim ~/.config/tmux/tmux.conf"
alias aliases="nvim ~/.config/alias.sh"
alias sxhkdrc="nvim ~/.config/sxhkd/sxhkdrc"
alias bspwmrc="nvim ~/.config/bspwm/bspwmrc"
alias lfrc="nvim ~/.config/lf/lfrc"

# stop weird alacritty incompatibilities when using ssh
alias ssh='TERM=xterm-256color ssh'

# Verbosity and settings that you pretty much just always are going to want.
alias \
	cp="cp -iv" \
	g="git" \
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
	YT="youtube-viewer" \
	sdn="sudo shutdown -h now" \
	e="$EDITOR" \
	v="$EDITOR" \
	p="sudo pacman" \

