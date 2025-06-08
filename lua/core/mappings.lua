--

--Mappings for TodoLocList
vim.api.nvim_set_keymap("n", "<leader>td", ":TodoLocList<CR>", { noremap = true, silent = true })

-- Disable arrow keys
vim.api.nvim_set_keymap("n", "<Up>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", "<NOP>", { noremap = true, silent = true })

--Window Resize Custom
vim.keymap.set("n", "<A-h>", "<C-w><")
vim.keymap.set("n", "<A-l>", "<C-w>>")
vim.keymap.set("n", "<A-k>", "<C-w>+")
vim.keymap.set("n", "<A-j>", "<C-w>-")

-- File navigation with Telescope

vim.keymap.set("n", "<C-f>", ":Telescope find_files<CR>", opts) -- Find files using Ctrl+F
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", opts) -- Find files by name
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", opts) -- Find text in files (grep)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts) -- Browse open buffers

-- file explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>", opts) -- toggle file explorer

-- buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<cr>", opts) -- go to next buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>", opts) -- go to previous buffer
vim.keymap.set("n", "<leader>bd", ":bdelete<cr>", opts) -- delete current buffer

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

-- Window navigation (these don't override default vim navigation)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts) -- Move to left window
vim.keymap.set("n", "<C-j>", "<C-w>j", opts) -- Move to window below
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) -- Move to window above
vim.keymap.set("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts) -- Decrease window height
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts) -- Increase window height
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts) -- Decrease window width
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts) -- Increase window width

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

-- In your Neovim config (init.lua or equivalent)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
--terminals (help for keybindings)
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
	for i, bufnr in ipairs(terminals) do
		print(bufnr .. ": " .. vim.api.nvim_buf_get_name(bufnr))
	end
	print("N: Create a new terminal")
	print("C: Minimise terminal")

	-- Prompt the user for a buffer number or 'N'
	local input = vim.fn.input("Enter terminal buffer number or 'N' for new: ")

	-- Check if user wants a new terminal
	if input:upper() == "N" then
		-- Check if there's an existing terminal window and close it
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(buf)
			if string.find(bufname, "term://") then
				vim.api.nvim_win_close(win, false)
				break
			end
		end
		-- Create a new terminal
		vim.cmd("botright 10split | term")
		return
	end

	if input:upper() == "C" then
		--close/minimise any open term session
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(buf)
			if string.find(bufname, "term://") then
				vim.api.nvim_win_close(win, true)
				break
			end
		end
		return
	end

	-- Parse the buffer number
	local term_bufnr = tonumber(input)

	-- Validate input
	if not term_bufnr or vim.fn.bufexists(term_bufnr) ~= 1 then
		print("Invalid buffer number!")
		return
	end

	-- Check if there's an existing terminal window and handle accordingly
	local term_win = nil
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bufname = vim.api.nvim_buf_get_name(buf)
		if string.find(bufname, "term://") then
			term_win = win
			-- If this is the window with our selected buffer, just switch to it
			if buf == term_bufnr then
				vim.api.nvim_set_current_win(win)
				return
			end
			break
		end
	end

	-- If a different terminal window is open, close it before opening the new one
	if term_win then
		vim.api.nvim_win_close(term_win, false)
	end

	-- Open the selected terminal in a new split
	vim.cmd("botright 10split | buffer " .. term_bufnr)
end
