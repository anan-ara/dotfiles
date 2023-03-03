# This sets up some environment variables, limits, your umask, and possibly
# other things. See ~/.localenv and /usr/local/etc/localenv.conf for
# details or to customize the behavior of localenv2. Don't remove this
# unless you know what you are doing; it will cause a lot of things to stop
# working properly.
if [ $SHLVL = 1 ]; then
	eval `/usr/local/bin/localenv2`
fi

# Default Apps
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="google-chrome-stable"
export VIDEO="mpv"
export IMAGE="sxiv"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export PAGER="less"

# Manually activate conda
export CONDA_AUTO_ACTIVATE_BASE=false

# Other XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

# Add my scripts
export PATH="$HOME/.local/bin:$PATH"

# Fixing Paths
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
# export ZDOTDIR=$HOME/.config/zsh
