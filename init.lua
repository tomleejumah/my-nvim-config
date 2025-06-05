-- Define leader key before loading any plugins
vim.g.mapleader = " "

-- General settings
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.wrap = true
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undofiles"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.guicursor = ""

vim.opt.mouse = ""
vim.api.nvim_create_autocmd("TermEnter", {
  callback = function()
    vim.opt.guicursor = "a:ver25"
  end,
})

vim.api.nvim_create_autocmd("TermLeave", {
  callback = function()
    vim.opt.guicursor = ""
  end,
})

-- Load core modules
require("core.plugins")
require("core.mappings")
require("core.lsp")
require("core.boilerplate")

-- require('core.terminal')
--require('core.todo_highlights')
--require("core.autosave")
