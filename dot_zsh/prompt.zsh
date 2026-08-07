# Everything but git is a zero-cost builtin.

setopt PROMPT_SUBST

# SSH_CONNECTION can't change mid-session -- compute this once, not per-prompt.
if [[ -n "$SSH_CONNECTION" ]]; then
  _prompt_user_host='%F{magenta}%n@%m%f '
else
  _prompt_user_host=''
fi

_prompt_git_branch() {
  local b dirty=""
  b=$(command git symbolic-ref --short HEAD 2>/dev/null) || b=$(command git rev-parse --short HEAD 2>/dev/null)
  [[ -z "$b" ]] && return
  # Staged or unstaged changes to tracked files only -- untracked files
  # (gitignored or not) are deliberately not flagged here.
  command git diff --quiet HEAD -- 2>/dev/null || dirty="*"
  print -n " %F{green}$b%f"
  [[ -n "$dirty" ]] && print -n " %F{yellow}$dirty%f"
}

_prompt_venv() {
  [[ -n "$VIRTUAL_ENV" ]] && print -n " %F{cyan}(${VIRTUAL_ENV:t})%f"
}

# Blank line before each prompt for visual separation between commands,
# except the very first render (fresh terminal's prompt would start
# pushed down from the top instead of flush against it) and right after
# running `clear` (defeats the point of clearing the screen).
_prompt_first_render=1
_prompt_skip_next_blank=""
preexec() {
  [[ "$1" == "clear" ]] && _prompt_skip_next_blank=1
}
precmd() {
  if [[ -n "$_prompt_first_render" ]]; then
    _prompt_first_render=""
  elif [[ -n "$_prompt_skip_next_blank" ]]; then
    _prompt_skip_next_blank=""
  else
    print
  fi
}

# %3~ truncates the directory to its last 3 path components (silently,
# no ellipsis marker -- ~/a/b/c/d shows as just b/c/d).
PROMPT='%B${_prompt_user_host}%F{blue}%3~%f$(_prompt_git_branch)$(_prompt_venv)
%(?.%F{green}.%F{red})❯%f%b '
