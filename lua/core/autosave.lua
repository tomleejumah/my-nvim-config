vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		vim.defer_fn(function()
			if vim.fn.mode() ~= "i" then
				vim.cmd("silent! write")
			end
		end, 500)
	end,
})
