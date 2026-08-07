alias lg=lazygit

# Official yazi shell wrapper (https://yazi-rs.github.io/docs/quick-start),
# so quitting yazi changes the shell's cwd to wherever you navigated.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}
bindkey -s '^o' 'y\n'  # zsh
