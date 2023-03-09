
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com
# cSpell:words ajeetdsouza cppflags ldflags pkgconfig pnpm nvim Nord gopath nvimpager ripgreprc ripgrep zoxide joshmedeski sharkdp neovim lucc

# set -gx fish_greeting # disable fish greeting
set -Ux BAT_THEME Dracula # 'sharkdp/bat' cat clone
set -Ux EDITOR nvim # 'neovim/neovim' text editor
set -Ux FZF_DEFAULT_COMMAND "fd --hidden --exclude '.git'"

set -Ux FZF_DEFAULT_OPTS "--reverse --no-info --pointer='▶' --marker='✓'' \
--ansi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6' --multi"

set -Ux FZF_TMUX_OPTS "-p --reverse --no-info --pointer='▶' --marker='✓'' \
--ansi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6' --multi"

set -Ux FZF_CTRL_R_OPTS "--border-label=' History ' --prompt=' '"

# export FZF_DEFAULT_OPTS="
# --layout=reverse
# --info=inline
# --height=80%
# --multi
# --color=16
# --prompt='∼ ' --pointer='▶' --marker='✓'
# "

set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
# set -Ux NODE_PATH "~/.nvm/versions/node/v16.19.0/bin/node" # 'nvm-sh/nvm'
# set -Ux PAGER ~/.local/bin/nvimpager # 'lucc/nvimpager'
# set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/rg/ripgreprc"
set -Ux VISUAL nvim

# ordered by priority - bottom up
fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path $HOME/.local/bin
# fish_add_path $HOME/.config/tmux/plugins/tmux-nvr/bin
# fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
		starship init fish | source # https://starship.rs/
		# zoxide init fish | source # 'ajeetdsouza/zoxide'
end

