require("git-conflict").setup({
	default_mappings = true,
	default_commands = true,
	disable_diagnostics = false,
	list_opener = "copen",
	highlights = {
		incoming = "DiffAdd",
		current = "DiffText",
	},
})

-- Default Keymaps for git-conflict.nvim
-- These are active only when `default_mappings = true`
-- No <leader>, just direct key presses in conflicted buffers:

-- ]x  → Jump to next conflict
-- [x  → Jump to previous conflict

-- co  → Choose ours (your current branch)
-- ct  → Choose theirs (incoming branch)
-- cb  → Choose both
-- c0  → Choose none
-- cx  → Mark conflict as resolved (after resolving sections)
