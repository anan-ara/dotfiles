
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com
# cSpell:words ajeetdsouza cppflags ldflags pkgconfig pnpm nvim Nord gopath nvimpager ripgreprc ripgrep zoxide joshmedeski sharkdp neovim lucc

set -gx fish_greeting # disable fish greeting
set -Ux BAT_THEME Dracula # 'sharkdp/bat' cat clone
set -Ux EDITOR vim # 'neovim/neovim' text editor
set -Ux VISUAL vim
set -Ux FZF_DEFAULT_COMMAND "fd --hidden --exclude '.git'"

set -Ux FZF_DEFAULT_OPTS "--reverse --no-info --prompt='❯ ' --pointer='▶' --marker='✓' \
 --ansi --multi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6'"

set -Ux FZF_TMUX_OPTS "-p --reverse --no-info --prompt='❯ ' --pointer='▶' --marker='✓' \
 --ansi --multi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6'"

set -Ux FZF_CTRL_R_OPTS "--border-label=' History ' --prompt='❯ '"

set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
# set -Ux NODE_PATH "~/.nvm/versions/node/v16.19.0/bin/node" # 'nvm-sh/nvm'
# set -Ux PAGER ~/.local/bin/nvimpager # 'lucc/nvimpager'
# set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/rg/ripgreprc"
# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set -Ux fish_cursor_default block
# Set the insert mode cursor to a line
set -Ux fish_cursor_insert line
# Set the replace mode cursor to an underscore
set -Ux fish_cursor_replace_one underscore
# Make the cursor work in tmux
set -Ux fish_vi_force_cursor

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
    zoxide init fish | source # 'ajeetdsouza/zoxide'
    fish_config theme choose Dracula
end

