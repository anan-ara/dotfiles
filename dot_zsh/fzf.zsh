# Ctrl-T: fzf's official "dedicated completion key binding" pattern
# (github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion) -- binds
# Ctrl-T to the same context-aware fuzzy completion **<Tab> normally
# triggers (ssh hosts, PIDs, env vars, generic path completion, etc.),
# invoked unconditionally instead of needing the ** trigger typed first.
# Tab itself is restored to plain zsh completion right after, so nothing
# about Tab changes. Doesn't shadow anything (zsh's own Ctrl-T default is
# transpose-chars), so this is additive, not a personal remap.
if command -v fzf >/dev/null 2>&1; then
  if command -v fd >/dev/null 2>&1; then
    # Override path/dir completion's default `find` backend with fd, for
    # the same speed + full-.gitignore-awareness reason fd was added as a
    # dependency in the first place (see .chezmoidata/packages.yaml).
    _fzf_compgen_path() {
      fd --hidden --follow --exclude .git --exclude node_modules . "$1"
    }
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
    }
  fi

  # Persistent (exported), not a transient prefix-assignment on the eval
  # below: fzf-completion re-reads $FZF_COMPLETION_TRIGGER fresh on every
  # keypress, not just once at definition time, so it has to stay set for
  # the life of the session -- a prefix assignment here would only apply
  # while the eval itself runs, leaving the trigger unset (and silently
  # defaulting back to '**') by the time Ctrl-T is actually pressed.
  export FZF_COMPLETION_TRIGGER=''

  FZF_ALT_C_COMMAND='' \
    eval "$(fzf --zsh | sed -n '/^### key-bindings.zsh ###/,/^### end: key-bindings.zsh ###/p; /^### completion.zsh ###/,/^### end: completion.zsh ###/p')"

  bindkey '^T' fzf-completion
  bindkey '^I' $fzf_default_completion

  # PERSONAL REMAP: Ctrl-R (via key-bindings.zsh above) is fzf's fuzzy,
  # full-history search instead of zsh's own substring-anchored
  # incremental search. Alt-C is suppressed, since it wasn't asked for.

  # Preview: bat for files, eza --tree for directories -- hidden by
  # default, toggled with `?`.
  export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--prompt='❯ '
--preview-window=hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always --line-range :500 {} || cat {})) || ([[ -d {} ]] && eza --tree --color=always --level=2 {}) || echo {}'
--bind '?:toggle-preview'
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
"

  # Labeled border for the history widget specifically, so it's visually
  # distinct from a plain fzf invocation elsewhere -- border-label does
  # nothing without --border also enabled.
  export FZF_CTRL_R_OPTS="--border --border-label=' History '"
else
  echo "zsh: fzf not found -- Ctrl-R fuzzy history search and Ctrl-T fuzzy completion disabled" >&2
fi
