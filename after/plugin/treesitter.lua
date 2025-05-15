require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
    "java", "go", "rust", "kotlin", "javascript", "html", "css", "gitignore", "tsx", "python", "php"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {}, -- You can leave this empty to install all parsers, or list parsers you don't want

  highlight = {
    enable = true,

    -- Disable specific languages for highlighting (optional, adjust as needed)
    disable = {
      "c", "rust" -- If you want to disable rust and c, for example
    },
    -- Or use a function for more flexibility
    disable = function(lang, buf)
      local max_filesize = 100 * 1024   -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    additional_vim_regex_highlighting = false,
  },
}
