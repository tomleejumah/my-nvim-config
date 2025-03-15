-- Indent Blankline configuration
require("ibl").setup({
  -- Use dots for indentation
  indent = {
    char = "⋅", -- You can use "⋅" (middle dot) or "." (regular dot)
  },
  -- Remove the underline
  scope = {
    show_start = false,
    show_end = false,
    highlight = "CursorColumn", -- Disable highlighting
  },
  -- Disable the underline globally
  whitespace = {
    highlight = "CursorColumn", -- Disable whitespace highlighting
  },
})
