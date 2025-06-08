-- Configure gitsigns
require('gitsigns').setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '✗' },
    topdelete    = { text = '‾' },
    changedelete = { text = '┃' },
  },
})
 vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
-- Customize highlight groups for the git signs
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00f746" })      -- Green for added lines
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e0cb07" })   -- Yellow for changed lines
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ed1c2d" })   -- Red for deleted lines
vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#D19A66" }) -- Orange for top deletions
vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#C678DD" }) -- Purple for changedelete
