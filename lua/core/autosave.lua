vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      if vim.fn.mode() ~= "i" then -- Don't save in insert mode
        vim.cmd("silent! write")
      end
    end, 500) -- 500ms delay before saving
  end,
})

