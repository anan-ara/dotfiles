return {
  -- Errors/warnings only show in the gutter and on hover, not as inline
  -- text at the end of the line.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },

  -- No auto-closing brackets/quotes.
  { "nvim-mini/mini.pairs", enabled = false },
}
