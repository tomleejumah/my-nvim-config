-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins with lazy.nvim
return require("lazy").setup({
	-- Treesitter for better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	--Context
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		config = false,
	},
	--  Comment
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- Enhanced f/t motions
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	--plantuml
	{
		"weirongxu/plantuml-previewer.vim",
		ft = { "plantuml" },
		dependencies = {
			"tyru/open-browser.vim",
		},
		config = function()
			vim.g["plantuml_previewer#plantuml_jar_path"] = "/usr/share/java/plantuml/plantuml.jar"
		end,
	},
	-- Surround text objects
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},

	-- Better quickfix list
	--{
	-- "kevinhwang91/nvim-bqf",
	--  ft = "qf",
	-- config = true,
	-- },

	-- Required dependency
	{ "nvim-neotest/nvim-nio" },

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- LSP progress indicator
	{
		"j-hui/fidget.nvim",
	},

	-- Undo tree
	{
		"mbbill/undotree",
	},

	-- Keymaps helper
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
	},

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict") -- path to your config file
		end,
	},

	{
		"tpope/vim-fugitive",
	},

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Session management
	{
		"olimorris/persisted.nvim",
	},

	-- File Explorer
	{
		"nvim-tree/nvim-tree.lua",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Theme
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("dracula").setup({
				colors = {
					bg = "#000000",
					black = "#000000",
				},
				transparent_bg = false,
			})
			vim.cmd.colorscheme("dracula")
		end,
	},
	-- Utilities
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	--GPT
	{
		"robitx/gp.nvim",
		config = function()
			local conf = {
				-- For customization, refer to Install > Configuration in the Documentation/Readme
			}
			require("gp").setup(conf)

			-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
		end,
	},
	{
		"glepnir/lspsaga.nvim",
	},

	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},
	-- Wakatime
	{ "wakatime/vim-wakatime" },

	-- Rust tools
	{
		"simrat39/rust-tools.nvim",
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
	},

	-- UI improvements
	-- {
	--   "folke/noice.nvim",
	--   event = "VeryLazy",
	--   dependencies = {
	--    "MunifTanjim/nui.nvim",
	--   },
	-- },

	-- Floating diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
	},

	-- Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
	},

	-- LSP Configuration
	{ "mfussenegger/nvim-jdtls" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "java-debug-adapter", "java-test" },
			})
		end,
	},
})
