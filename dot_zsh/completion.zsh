# Only rebuild/security-check the completion dump once a day -- compinit
# does real stat() work checking $fpath permissions every time otherwise.
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# menu select needs complist loaded to actually work (arrow-key nav,
# colorized listings) -- not a separate, optional feature.
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Shift-Tab cycles backward through the menu-select listing, symmetric to
# Tab cycling forward. Unbound by default in stock zsh (no shadowing here
# -- purely additive), unlike reverse-menu-complete's forward counterpart.
bindkey '^[[Z' reverse-menu-complete
