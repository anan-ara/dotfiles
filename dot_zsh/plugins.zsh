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
