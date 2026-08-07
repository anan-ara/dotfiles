export HISTFILE="${HOME}/.cache/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# Disable less history files
export LESSHISTFILE=-

# zsh auto-selects vi keybindings at startup if $EDITOR/$VISUAL contains
# the substring "vi" -- which "nvim" does. Force emacs (zsh's real
# default) explicitly so the editor choice doesn't accidentally control
# the shell's keybinding scheme.
bindkey -e

setopt complete_in_word       # complete from both ends of the word if the cursor is in the middle
setopt always_to_end          # move the cursor to the end of the word after a full completion

setopt auto_pushd             # cd pushes the previous directory onto the stack automatically
setopt pushd_ignore_dups      # don't push a directory onto the stack if it's already there
setopt pushd_minus            # swap the meaning of cd +N/-N stack-position directions

setopt share_history          # Share history between all sessions.
setopt extended_history       # record timestamp of command in HISTFILE

setopt hist_find_no_dups      # do not show duplicates when pressing up in history
setopt hist_ignore_dups       # do not save a command if it's the same as the previous one
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry.

setopt extended_glob          # extra glob operators (^ ~ #), purely additive syntax
setopt interactive_comments   # allow # comments when typing interactively
unsetopt beep                 # no terminal bell on error
unsetopt flowcontrol          # disable ctrl-s/ctrl-q terminal freeze
