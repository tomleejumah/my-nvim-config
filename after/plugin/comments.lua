require("Comment").setup({
	sticky = false,
	ignore = "^$",
	padding = true,
	post_hook = function(ctx)
		if ctx.range.srow == ctx.range.erow then
			-- do something with the current lines
			vim.cmd("normal! j")
		else
			-- do something with lines range
			vim.cmd("normal! '>j")
		end
	end,
})

vim.keymap.set("n", "<C-_>", "<leader>gcc", { remap = true })
vim.keymap.set("v", "<C-_>", "<leader>gb", { remap = true })
vim.keymap.set("n", "<leader>/", "gcA", { remap = true })
vim.keymap.set("v", "<leader>/", "gcA", { remap = true })
