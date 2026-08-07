source "${0:h}/plugins.zsh"

# GNU coreutils ahead of the BSD ones on PATH -- needs brew shellenv from
# plugins.zsh (for `brew --prefix`) to already have run.
if [[ $OS == "Darwin"* ]]; then
    PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
fi

# Colorize completion listings (and `ls`) to match the Dracula theme used
# everywhere else. Computed at shell startup rather than hardcoded, so
# switching themes is just changing the name below. Must run before
# completion.zsh, which consumes $LS_COLORS.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate dracula)"
else
  echo "zsh: vivid not found -- \$LS_COLORS not set" >&2
fi

source "${0:h}/prompt.zsh"
source "${0:h}/completion.zsh"
source "${0:h}/options.zsh"
source "${0:h}/commands.zsh"
