require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "java",
    "go", "rust", "kotlin", "javascript", "html", "css", "gitignore", "tsx",
    "typescript", "python", "bash", "json", "yaml", "toml", "dockerfile", "sql",
  },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  modules = {}, -- Empty modules table to satisfy the required field
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100KB limit
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
})
