-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Everything below is a `dot_vimrc` remap that LazyVim doesn't already cover
-- (checked against LazyVim's own keymaps.lua before adding any of these --
-- Y=y$, wrapped-line j/k, <C-hjkl> window nav, reselect-after-indent, and
-- <Esc> clearing search highlight are all already stock, so they're not
-- repeated here).

-- Keep search matches and half-page jumps centered on screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Search Result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page Down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page Up (centered)" })

-- Switch to last buffer -- Ctrl-S is LazyVim's Save File, so this lives on
-- Ctrl-\ instead (unbound by default in both vim and Neovim)
vim.keymap.set("n", "<C-\\>", "<C-^>", { desc = "Switch to Last Buffer" })

-- Tab to jump to matching element (personal preference -- shadows Tab's
-- default of jumping forward in the jumplist)
vim.keymap.set("n", "<Tab>", "%", { desc = "Jump to Matching Element" })

-- :W to save a file that needs root, without leaving nvim or losing changes
vim.api.nvim_create_user_command("W", function()
  vim.cmd("write !sudo tee % > /dev/null")
  vim.cmd("edit!")
end, {})
