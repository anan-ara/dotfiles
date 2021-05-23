# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Get fzf shortcuts
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh

# LFCD="/usr/share/lf/lfcd.sh"
# if [ -f "$LFCD" ]; then
  # source "$LFCD"
  # bindkey -s '^o' 'lfcd\n'  # zsh
# fi

# Source other config files
source ~/.config/alias.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/p10k.zsh ]] || source ~/.config/p10k.zsh

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

### Added by Zinit's installer
if [[ ! -f $HOME/.config/zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.config/zsh/.zinit" && command chmod g-rwX "$HOME/.config/zsh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.config/zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.config/zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light rupa/z
zinit light zsh-users/zsh-history-substring-search
zinit light jeffreytse/zsh-vi-mode

zinit snippet /usr/share/fzf/key-bindings.zsh
zinit snippet /usr/share/fzf/completion.zsh
zinit snippet /usr/share/lf/lfcd.sh

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit ice depth=2
zinit light zsh-users/zsh-syntax-highlighting

# bindings for plugins
bindkey '^ ' autosuggest-accept
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
autoload -U colors && colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zmodload zsh/complist
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# LFCD
bindkey -s '^o' 'lfcd\n'  # zsh

# setopts from omz
unsetopt menu_complete   # do not autoselect the first completion entry
# unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt auto_cd
setopt complete_in_word
setopt always_to_end

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Automatically start X server
# if [[ "$(tty)" = "/dev/tty1" ]]; then
	# startx -- -dpi 192
# fi

