#!/bin/sh

# Use neovim for vim if present.
# command -v nvim >/dev/null && alias vim="nvim" vimdiff="nvim -d"
command -v nvim >/dev/null && vimdiff="nvim -d"

# easily access files
alias vimrc="nvim ~/.vimrc"
alias tmuxconf="nvim ~/.tmux.conf"
alias zshrc="nvim ~/.zshrc"
alias aliases="nvim ~/zsh/alias.sh"
# alias sxhkdrc="nvim ~/.config/sxhkd/sxhkdrc"
# alias bspwmrc="nvim ~/.config/bspwm/bspwmrc"
alias lfrc="nvim ~/.config/lf/lfrc"

# stop weird alacritty incompatibilities when using ssh
alias ssh='TERM=xterm-256color ssh'
alias k='TERM=xterm-256color ssh knuth'

# Verbosity and settings that you pretty much just always are going to want.
alias \
	cp="cp -iv" \
	g="git" \
	t="tmux" \
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
	ccat="highlight --out-format=ansi"
	# diff="diff --color=auto" \

# These common commands are just too long! Abbreviate them.
alias \
	ka="killall" \
	YT="youtube-viewer" \
	sdn="sudo shutdown -h now" \
	e="$EDITOR" \
	v="$EDITOR" \
	p="sudo pacman" \

# If you do a lot of C compiling, this saves finger wear
# (Note that only one filename may be specified.)
# alias     C='gcc -o \!* \!*.c '
# alias     C++='g++ -o \!* \!*.[Cc]*[^~] '

# alias     mkdir='nocorrect mkdir'     # running on any of the arguments passed to the command.
# alias     man='nocorrect man'

alias     ll='ls -lA'
alias     la='ls -A'
alias     sizeof='du -sh'     # Useful for checking the size of directories and regular files
