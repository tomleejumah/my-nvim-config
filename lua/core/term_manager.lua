local M = {}

function M.focus_nvim_tree()
	local found = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_buf_get_option(buf, "filetype")
		if ft == "NvimTree" then
			vim.api.nvim_set_current_win(win)
			found = true
			break
		end
	end
	if not found then
		vim.cmd("NvimTreeToggle")
	end
end

function M.prompt_terminal()
	local terminals = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if string.find(bufname, "term://") then
			table.insert(terminals, bufnr)
		end
	end
	if #terminals == 0 then
		vim.cmd("botright 10split | term")
		return
	end

	-- Build prompt message
	local prompt_lines = { "Available terminal buffers:" }
	for i, bufnr in ipairs(terminals) do
		table.insert(prompt_lines, bufnr .. ": " .. vim.api.nvim_buf_get_name(bufnr))
	end
	table.insert(prompt_lines, "N: Create a new terminal")
	table.insert(prompt_lines, "M: Minimise terminal")

	-- Display all at once, then prompt
	print(table.concat(prompt_lines, "\n"))
	local input = vim.fn.input(": ")

	if input:upper() == "N" then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(buf)
			if string.find(bufname, "term://") then
				vim.api.nvim_win_close(win, false)
				break
			end
		end
		vim.cmd("botright 10split | term")
		return
	end

	if input:upper() == "M" then
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

	local term_bufnr = tonumber(input)
	if not term_bufnr or vim.fn.bufexists(term_bufnr) ~= 1 then
		print("Invalid buffer number!")
		return
	end

	-- Check if buffer is already in a window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if buf == term_bufnr then
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	vim.cmd("botright 10split | buffer " .. term_bufnr)
end

return M
