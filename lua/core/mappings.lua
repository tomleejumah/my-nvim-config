local opts = { noremap = true, silent = true }

--Mappings for TodoLocList
vim.api.nvim_set_keymap("n", "<leader>td", ":TodoLocList<CR>", { noremap = true, silent = true })

-- Disable arrow keys
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", { noremap = true, silent = true })

-- File navigation with Telescope
vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>", opts) -- Find files using Ctrl+F
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", opts) -- Find files by name
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", opts) -- Find text in files (grep)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts) -- Browse open buffers

-- file explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>", opts) -- toggle file explorer

--make make_it_rain
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>fmm", "<cmd>CellularAutomaton game_of_life<CR>")

local function safe_buffer_nav(direction)
	return function()
		local current_buf = vim.api.nvim_get_current_buf()
		local bufs = vim.tbl_map(function(b)
			return b.bufnr
		end, vim.fn.getbufinfo({ buflisted = 1 }))

		local index = vim.fn.index(bufs, current_buf)
		local step = direction == "next" and 1 or -1

		for _ = 1, #bufs do
			index = index + step
			if index < 0 then
				index = #bufs - 1
			end
			if index >= #bufs then
				index = 0
			end

			local target_buf = bufs[index + 1]
			local bt = vim.bo[target_buf].buftype
			if
				vim.api.nvim_buf_is_valid(target_buf)
				and not vim.tbl_contains({ "terminal", "nofile", "prompt" }, bt)
			then
				vim.api.nvim_set_current_buf(target_buf)
				return
			end
		end

		vim.notify("No non-terminal buffers found", vim.log.levels.INFO)
	end
end

-- buffer shortcuts keybindings
vim.keymap.set("n", "<C-n>", safe_buffer_nav("next"), { desc = "Next non-terminal buffer", silent = true })
vim.keymap.set("n", "<C-p>", safe_buffer_nav("previous"), { desc = "Previous non-terminal buffer", silent = true })
vim.keymap.set("n", "<C-l>", ":ls<CR>", { desc = "List buffers", silent = true }) -- Simple buffer list

-- File operations shortcuts
vim.keymap.set("n", "<leader>w", ":w<CR>", opts) -- Save file
vim.keymap.set("n", "<leader>q", ":q<CR>", opts) -- Quit
vim.keymap.set("n", "<leader>x", ":x<CR>", opts) -- Save and quit
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

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts) -- Move to left window
vim.keymap.set("n", "<C-j>", "<C-w>j", opts) -- Move to window below
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) -- Move to window above
vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- Custom resizing with ALT and :resize -2
vim.keymap.set("n", "<A-k>", ":resize -2<CR>", opts) -- Decrease window height by 2
vim.keymap.set("n", "<A-j>", ":resize +2<CR>", opts) -- Increase window height by 2
vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", opts) -- Decrease window width by 2
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", opts) -- Increase window width by 2

-- Move text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts) -- Move selected text down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts) -- Move selected text up

-- Keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z", opts) -- Join lines while keeping cursor position

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", opts) -- Clear search highlighting

-- LSP actions
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" }) -- Show code actions
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }) -- Show diagnostics popup
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Code Lens" }) -- Run code lens

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

-- Trouble.nvim keymaps (diagnostics viewer)
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" }) -- Toggle trouble panel
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" }) -- Show workspace diagnostics
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" }) -- Show document diagnostics
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List" }) -- Show location list
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List" }) -- Show quickfix list
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" }) -- Show LSP references in Trouble

--persistance yank
vim.keymap.set("x", "<leader>p", [["_dP]], { noremap = true, silent = true })

-- Persistence.nvim keymaps (session management)

-- Restore session
vim.keymap.set("n", "<C-p>s", function()
	require("persistence").load()
end, { desc = "Restore Session" })

-- Restore last session
vim.keymap.set("n", "<C-p>l", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })

-- Don't save current session
vim.keymap.set("n", "<C-p>d", function()
	require("persistence").stop()
end, { desc = "Don't Save Current Session" })

-- Which-key keymaps (help for keybindings)
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

--terminals (help for keybindings)
local term_manager = require("core.term_manager")

vim.keymap.set("n", "<leader>tt", term_manager.prompt_terminal, { noremap = true, silent = true })

-- ESC in terminal mode → exit + focus NvimTree
--vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("t", "<Esc>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	vim.defer_fn(term_manager.focus_nvim_tree, 100)
end, { noremap = true, silent = true })
