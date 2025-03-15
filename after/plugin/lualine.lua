-- Lualine configuration with WakaTime
require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = "|",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {
      -- Show WakaTime status
      function()
        return vim.fn['WakaTimeStatus']() or "WakaTime: N/A"
      end,
      'encoding', 'fileformat', 'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'nvim-tree', 'fugitive' }
})

-- Make sure WakaTime is running
vim.cmd("WakaTimeApiCall")

-- Now WakaTime status should show in your lualine! 🚀
