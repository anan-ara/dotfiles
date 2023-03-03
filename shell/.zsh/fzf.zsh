# fzf Settings
# ---------

# Use fd if available
command -v fd >/dev/null 2>&1 && export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND . $HOME"
# export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d . $HOME"

export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--color=16
--prompt='∼ ' --pointer='▶' --marker='✓'
"

# --preview-window=:hidden
# --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
# --bind '?:toggle-preview'

# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/vim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOME}/.vim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.vim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.vim/plugged/fzf/shell/key-bindings.zsh"
