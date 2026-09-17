alias lg lazygit
alias h herdr

# Official yazi shell wrapper (https://yazi-rs.github.io/docs/quick-start),
# so quitting yazi changes the shell's cwd to wherever you navigated.
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end
bind \co y
