-- Custom TODO highlights
vim.api.nvim_create_augroup("TodoHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = "TodoHighlight",
  pattern = "*",
  callback = function()
    -- Define your custom todo keywords and their highlight groups
    local todo_highlights = {
      ["TODO"] = { fg = "#2563EB", bold = true },  -- Orange
      ["FIXME"] = { fg = "#FF0000", bold = true }, -- Red
      ["BUG"] = { fg = "#FF1493", bold = true },   -- Deep Pink
      ["HACK"] = { fg = "#9400D3", bold = true },  -- Purple
      ["NOTE"] = { fg = "#1E90FF", bold = true },  -- Dodger Blue
      ["PERF"] = { fg = "#32CD32", bold = true },  -- Lime Green
      ["TEST"] = { fg = "#FFD700", bold = true },  -- Gold
      ["WARN"] = { fg = "#FFA500", bold = true },  -- Orange
    }

    -- Create the highlight groups
    for keyword, color_opts in pairs(todo_highlights) do
      vim.api.nvim_set_hl(0, "TodoKeyword" .. keyword, color_opts)
    end

    -- Get all keywords for match pattern
    local keywords = {}
    for keyword, _ in pairs(todo_highlights) do
      table.insert(keywords, keyword)
    end
    local pattern = table.concat(keywords, "\\|")

    -- Create the match patterns for different comment styles
    vim.fn.matchadd("TodoKeywordTODO", "TODO\\ze[:)]\\|TODO\\ze\\s")
    vim.fn.matchadd("TodoKeywordFIXME", "FIXME\\ze[:)]\\|FIXME\\ze\\s")
    vim.fn.matchadd("TodoKeywordBUG", "BUG\\ze[:)]\\|BUG\\ze\\s")
    vim.fn.matchadd("TodoKeywordHACK", "HACK\\ze[:)]\\|HACK\\ze\\s")
    vim.fn.matchadd("TodoKeywordNOTE", "NOTE\\ze[:)]\\|NOTE\\ze\\s")
    vim.fn.matchadd("TodoKeywordPERF", "PERF\\ze[:)]\\|PERF\\ze\\s")
    vim.fn.matchadd("TodoKeywordTEST", "TEST\\ze[:)]\\|TEST\\ze\\s")
    vim.fn.matchadd("TodoKeywordWARN", "WARN\\ze[:)]\\|WARN\\ze\\s")
  end,
})
