-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Wrap prose at 79 columns as you type, with a highlighted column marking
-- the limit -- scoped to filetypes where hard-wrapping text is wanted.
-- Left off everywhere else, since auto-breaking a line while typing code
-- is almost never wanted.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.textwidth = 79
    vim.opt_local.colorcolumn = "+1"
  end,
})
