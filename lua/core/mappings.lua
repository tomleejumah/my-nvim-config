local opts = { noremap = true, silent = true }


-- vim.api.nvim_set_keymap('n', '<leader>t', ':buffer term://*<CR>', { noremap = true, silent = true })

-- Disable arrow keys
vim.api.nvim_set_keymap('n', '<Up>', '<NOP>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', '<NOP>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Left>', '<NOP>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', '<NOP>', { noremap = true, silent = true })

--custom nvim-tree mappings
vim.cmd([[
    cabbrev NTT NvimTreeToggle
    cabbrev NTF NvimTreeFocus
    cabbrev NTC NvimTreeCollapse
    cabbrev NTFF NvimTreeFindFile
]])

-- Toggle comments with Ctrl+/
vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, { desc = 'Toggle comment' })
vim.keymap.set('v', '<C-_>', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
  { desc = 'Toggle comment' })

-- File navigation with Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", opts) -- Find files by name
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", opts)  -- Find text in files (grep)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts)    -- Browse open buffers

-- File explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts) -- Toggle file explorer

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", opts)     -- Go to next buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", opts) -- Go to previous buffer
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", opts)   -- Delete current buffer

-- File operations shortcuts
vim.keymap.set("n", "<leader>w", ":w<CR>", opts)       -- Save file
vim.keymap.set("n", "<leader>q", ":q<CR>", opts)       -- Quit
vim.keymap.set("n", "<leader>x", ":x<CR>", opts)       -- Save and quit
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts) -- Copy to system clipboard

-- Markdown preview
vim.keymap.set("n", "<leader>mm", ":MarkdownPreviewToggle<CR>", opts) -- Toggle markdown preview

-- Insert mode shortcuts
vim.keymap.set("i", "jk", "<Esc>", opts) -- Exit insert mode with jk

-- Undo tree
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", opts) -- Toggle undo tree view

-- Sessions management
vim.keymap.set("n", "<leader>ss", ":PersistedSave<CR>", opts) -- Save session
vim.keymap.set("n", "<leader>sl", ":PersistedLoad<CR>", opts) -- Load session

-- Visual Mode improvements
vim.keymap.set("v", "<", "<gv", opts) -- Indent left and stay in visual mode
vim.keymap.set("v", ">", ">gv", opts) -- Indent right and stay in visual mode

-- LSP keymaps
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)     -- Go to definition
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)     -- Find references
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- Go to implementation
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                            -- Show documentation hover

-- Window navigation (these don't override default vim navigation)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts) -- Move to left window
vim.keymap.set("n", "<C-j>", "<C-w>j", opts) -- Move to window below
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) -- Move to window above
vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)             -- Decrease window height
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)           -- Increase window height
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)  -- Decrease window width
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts) -- Increase window width

-- Move text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts) -- Move selected text down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts) -- Move selected text up

-- Keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z", opts) -- Join lines while keeping cursor position

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", opts) -- Clear search highlighting

-- LSP actions
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })        -- Show code actions
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }) -- Show diagnostics popup
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Code Lens" })             -- Run code lens

-- Toggle relative line numbers
function _G.toggle_relative_number()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = true
  end
end

vim.keymap.set("n", "<leader>tr", ":lua toggle_relative_number()<CR>", opts) -- Toggle relative line numbers

-- Save and source current file (useful for configuration files)
vim.keymap.set("n", "<leader>so", ":w<CR>:source %<CR>", opts) -- Save and reload current file

-- Create new file function
local function create_new_file()
  local new_file = vim.fn.input("New file: ")
  if new_file ~= "" then
    vim.cmd("edit " .. new_file)
  end
end

vim.keymap.set("n", "<leader>nf", create_new_file, { desc = "Create new file" }) -- Create a new file

-- Terminal function
function _G.OpenTerminalBottomThird()
  -- Check if a terminal buffer already exists
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      -- Switch to the existing terminal window
      vim.cmd("botright split | resize " .. math.floor(vim.o.lines * 0.33))
      vim.cmd("buffer " .. buf)
      vim.cmd("startinsert")
      return
    end
  end

  -- If no terminal buffer exists, create a new one
  local height = math.floor(vim.o.lines * 0.33)
  vim.cmd("botright split | resize " .. height)
  vim.cmd("term")

  -- Disable line numbers and enter insert mode
  vim.api.nvim_win_set_option(0, "number", false)
  vim.api.nvim_win_set_option(0, "relativenumber", false)
  vim.cmd("startinsert")
end

-- Toggle terminal
-- vim.keymap.set("n", "<leader>tt", ":lua OpenTerminalBottomThird()<CR>", opts) -- Open terminal in bottom third

vim.api.nvim_set_keymap("n", "<leader>tt", ":lua PromptTerminalBuffer()<CR>", { noremap = true, silent = true })

function PromptTerminalBuffer()
  local terminals = {}

  -- Find all terminal buffers and store their numbers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if string.find(bufname, "term://") then
      table.insert(terminals, bufnr)
    end
  end

  if #terminals == 0 then
    -- No terminals exist, create a new one
    vim.cmd("botright 10split | term")
    return
  end

  -- Display the list of terminal buffers
  print("Available terminal buffers:")
  for _, bufnr in ipairs(terminals) do
    print(bufnr .. ": " .. vim.api.nvim_buf_get_name(bufnr))
  end

  -- Prompt the user for a buffer number
  local term_bufnr = tonumber(vim.fn.input("Enter terminal buffer number: "))

  -- Validate input and switch to selected buffer
  if term_bufnr and vim.fn.bufexists(term_bufnr) == 1 then
    vim.cmd("botright 10split | buffer " .. term_bufnr)
  else
    print("Invalid buffer number!")
  end
end

-- Trouble.nvim keymaps (diagnostics viewer)
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })                              -- Toggle trouble panel
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" }) -- Show workspace diagnostics
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })   -- Show document diagnostics
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List" })                       -- Show location list
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List" })                      -- Show quickfix list
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" })                       -- Show LSP references in Trouble

-- Persistence.nvim keymaps (session management)
vim.keymap.set("n", "<leader>ps", function() require("persistence").load() end, { desc = "Restore Session" })            -- Restore session
vim.keymap.set("n", "<leader>pl", function() require("persistence").load({ last = true }) end,
  { desc = "Restore Last Session" })                                                                                     -- Restore last session
vim.keymap.set("n", "<leader>pd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" }) -- Don't save session

-- Which-key keymaps (help for keybindings)
vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end,
  { desc = "Buffer Local Keymaps (which-key)" })

-- REMOVED MAPPINGS THAT OVERRIDE DEFAULT VIM NAVIGATION:
-- vim.keymap.set("n", "j", "jzz", opts)       -- Removed: This overrides default j movement
-- vim.keymap.set("n", "k", "kzz", opts)       -- Removed: This overrides default k movement
-- vim.keymap.set("n", "o", "o<Esc>", opts)    -- Removed: This prevents using 'o' for inserting new line and entering insert mode
-- vim.keymap.set("n", "O", "O<Esc>", opts)    -- Removed: This prevents using 'O' for inserting new line above and entering insert mode
