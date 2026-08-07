OS=$(uname)

# /opt/homebrew is Apple Silicon's prefix, /usr/local is Intel's -- check
# both rather than assume one, so this works on either Mac. On Linux,
# /home/linuxbrew/.linuxbrew is Homebrew's own standard prefix (see
# .chezmoiscripts/run_onchange_install-packages.sh.tmpl) -- not present
# at all if Linuxbrew was declined in favor of native packages, in which
# case this cleanly no-ops and native packages are already on $PATH.
if [[ $OS == "Darwin"* ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Autosuggestions (no plugin manager -- just the two plugins, sourced
# directly wherever the package manager put them)
_plugin_found=""
for _plugin_path in \
    "$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -f "$_plugin_path" ]] && source "$_plugin_path" && _plugin_found=1 && break
done
[[ -z "$_plugin_found" ]] && echo "zsh: zsh-autosuggestions not found -- autosuggestions disabled" >&2
unset _plugin_path _plugin_found

# Deferred via a one-shot precmd hook rather than sourced synchronously
# here. create_dot_zshrc's create-once semantics mean future tool
# installers (nvm, pyenv, etc.) append their own lines below `source
# ~/.zsh/base.zsh` in ~/.zshrc -- sourcing this at a fixed point in this
# file would still only guarantee it's last relative to base.zsh's own
# content, not relative to whatever gets appended afterward. Syntax
# highlighting wraps ZLE widgets and can only wrap ones that already
# exist at source time, so it has to load after everything else,
# appended lines included. precmd fires right before the first prompt,
# i.e. after the whole of ~/.zshrc (appends included) has been read --
# this guarantees that regardless of what's appended later.
_load_syntax_highlighting() {
  local plugin_path
  for plugin_path in \
      "$(brew --prefix 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
      /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
      /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    if [[ -f "$plugin_path" ]]; then
      source "$plugin_path"
      add-zsh-hook -d precmd _load_syntax_highlighting
      return
    fi
  done
  echo "zsh: zsh-syntax-highlighting not found -- syntax highlighting disabled" >&2
  add-zsh-hook -d precmd _load_syntax_highlighting
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _load_syntax_highlighting
