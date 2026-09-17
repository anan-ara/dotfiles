# Ctrl-T: the fish equivalent of fzf's official zsh "dedicated completion
# key binding" pattern (github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion)
# -- rebinds Ctrl-T from fzf's plain file-picker widget to fzf_complete,
# the same context-aware fuzzy completion Shift-Tab normally triggers
# (falls back to fish's own native `complete -C` completion for anything
# without a per-command handler). Shift-Tab is unbound afterward to
# consolidate onto the one dedicated key -- fish ships no default
# Shift-Tab binding of its own, so nothing is lost. Doesn't shadow
# anything (fish has no default Ctrl-T binding either), so this is
# additive, not a personal remap.
#
# Unlike the zsh side, there's no fd-backed override here: fzf_complete's
# main path defers entirely to fish's own native completion engine
# (`complete -C`) rather than shelling out to `find`/`fd`, so there's no
# equivalent hook to point at fd.
if command -q fzf
    set -lx FZF_ALT_C_COMMAND ''
    fzf --fish | sed -n '/^### key-bindings.fish ###/,/^### end: key-bindings.fish ###/p; /^### completion.fish ###/,/^### end: completion.fish ###/p' | source

    bind ctrl-t fzf_complete
    bind -M insert ctrl-t fzf_complete
    bind --erase shift-tab
    bind --erase -M insert shift-tab

    # PERSONAL REMAP: Ctrl-R (via key-bindings.fish above) is fzf's fuzzy,
    # full-history search instead of fish's own history search. Alt-C is
    # suppressed, since it wasn't asked for.

    # Preview: bat for files, eza --tree for directories -- hidden by
    # default, toggled with `?`. Written in real fish syntax (not the zsh
    # side's `[[ ]] && (...) || (...)`): fzf's fish integration runs
    # --preview through fish itself, where `(...)` means command
    # substitution, not subshell grouping.
    set -gx FZF_DEFAULT_OPTS "
--layout=reverse
--info=inline
--height=80%
--multi
--prompt='❯ '
--preview-window=hidden
--preview 'if test -f {}; bat --style=numbers --color=always --line-range :500 {}; or cat {}; else if test -d {}; eza --tree --color=always --level=2 {}; else; echo {}; end'
--bind '?:toggle-preview'
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
"

    # Labeled border for the history widget specifically, so it's visually
    # distinct from a plain fzf invocation elsewhere -- border-label does
    # nothing without --border also enabled.
    set -gx FZF_CTRL_R_OPTS "--border --border-label=' History '"
else
    echo "fish: fzf not found -- Ctrl-R fuzzy history search and Ctrl-T fuzzy completion disabled" >&2
end
