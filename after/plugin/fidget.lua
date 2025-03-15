-- Configure fidget.nvim for showing LSP progress
require("fidget").setup({
  text = {
    spinner = "dots", -- Animation style
  },
  window = {
    relative = "win", -- Position relative to the window
    blend = 0,        -- Fully opaque
    zindex = 1,       -- Stacking order
  },
  sources = {         -- Sources to configure
    ["null-ls"] = {   -- Name of source
      ignore = false, -- Don't ignore notifications from null-ls
    },
  },
})
