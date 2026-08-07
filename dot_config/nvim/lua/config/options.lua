-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Everything else -- mouse=a, ignorecase+smartcase, confirm=true, undofile,
-- foldmethod=indent+foldlevel=99, termguicolors, SSH-aware clipboard via
-- OSC52, etc. -- already matches what dot_vimrc sets by hand, so only the
-- two overrides below are needed.

-- Absolute line numbers only, no relative numbering.
vim.opt.relativenumber = false

-- Disable snacks.nvim's scroll/indent/etc. animations -- instant jumps
-- (e.g. Ctrl-U/Ctrl-D) instead of an animated transition.
vim.g.snacks_animate = false
