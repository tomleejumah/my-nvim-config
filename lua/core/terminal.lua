-- Floating terminal function
local function open_floating_terminal()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded'
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.cmd('term')
  vim.cmd('startinsert')
end

-- Set up the function and key mappings
vim.api.nvim_create_user_command('FloatingTerm', open_floating_terminal, {})
vim.api.nvim_set_keymap('n', '<F12>', ':FloatingTerm<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

return {
  open_floating_terminal = open_floating_terminal
}
