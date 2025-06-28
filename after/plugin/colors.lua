function ColorPencils()
	-- LSP CodeLens highlights
	vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#777777", italic = true })
	vim.api.nvim_set_hl(0, "LspCodeLensText", { fg = "#777777", italic = true })
	vim.api.nvim_set_hl(0, "LspCodeLensRefText", { fg = "#777777", italic = true })
	vim.api.nvim_set_hl(0, "LspCodeLensRefIcon", { fg = "#777777", italic = true })
	vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = "#777777", italic = true })

	-- Nvim-tree background
	vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#000000" })

	-- Window separator
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#444444" })
	vim.opt.winhighlight = "WinSeparator:WinSeparator" -- Explicitly link highlight

	-- Color column guide line
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#444444" })

	-- Tone down diagnostic colors
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#d4a62f" }) -- Muted yellow
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#d4a62f" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#b8941f", italic = true })

	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#6a9dc7" }) -- Softer blue
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#6a9dc7" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#5a87b5", italic = true })

	-- vim.api.nvim_set_hl(0, "DiagnosticError", { italic = true }) -- Slightly muted red

	-- Setup diagnostic signs
	local signs = { Error = "●", Warn = "!", Hint = "󰛩", Info = "➤" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

ColorPencils()
