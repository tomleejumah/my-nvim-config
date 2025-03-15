-- LSP Configuration
local lspconfig = require('lspconfig')

-- LSP Attach Function with Keybindings
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Setup diagnostic signs
local signs = { Error = "✗", Warn = "!", Hint = "➤", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = "● " },
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- Get LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup LSP servers
local function setup_lsp_servers()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "rust_analyzer",
      "gopls",
      "ts_ls",
      "lua_ls",
      "jdtls",                  -- Java
      "kotlin_language_server", -- Kotlin
      "intelephense",           -- PHP
      "pyright",                -- Python
      "ruff",                   -- Python linter
      "clangd",                 -- C/C++
      "eslint",                 -- JavaScript/TypeScript linter
      "html",                   -- HTML
      "cssls",                  -- CSS
      "emmet_ls",               -- Emmet
    },
  })

  -- Enhanced JavaScript/TypeScript Configuration
  lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  })

  -- ESLint configuration
  lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  })

  -- Enhanced Kotlin Configuration
  lspconfig.kotlin_language_server.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts", ".git"),
    settings = {
      kotlin = {
        compiler = {
          jvm = {
            target = "17"
          }
        }
      }
    }
  })

  -- Java configuration
  lspconfig.jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('pom.xml', 'gradle.build', 'build.gradle', '.git'),
  })

  -- Python
  lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  lspconfig.ruff.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Go
  lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  })

  -- Web Development
  lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Rust
  require("rust-tools").setup({
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
        },
      },
    },
  })

  -- C/C++
  lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  })

  -- PHP
  lspconfig.intelephense.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Lua
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Setup nvim-cmp
local function setup_completion()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
    }),
  })
end

-- Setup format on save
local function setup_formatting()
  -- Setup conform.nvim
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      rust = { "rustfmt" },
      go = { "gofmt" },
      python = { "black" },
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      php = { "php-cs-fixer" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      html = { "prettier" },
      css = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })

  -- Setup null-ls for additional formatting capabilities
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier,     -- JavaScript/TypeScript
      null_ls.builtins.formatting.gofmt,        -- Go
      null_ls.builtins.formatting.rustfmt,      -- Rust
      null_ls.builtins.formatting.stylua,       -- Lua
      null_ls.builtins.formatting.black,        -- Python
      null_ls.builtins.formatting.phpcsfixer,   -- PHP
      null_ls.builtins.formatting.clang_format, -- C/C++
    },
  })

  -- Set up format on save for specific file types
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.c", "*.cpp", "*.h", "*.rs", "*.go", "*.ts", "*.tsx", "*.js", "*.jsx", "*.py", "*.html", "*.css", "*.java", "*.kt", "*.php" },
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

-- Setup WakaTime
local function setup_wakatime()
  -- Make sure you have the WakaTime plugin installed
  -- You can install it with your plugin manager
  -- For example, with packer:
  -- use { 'wakatime/vim-wakatime' }

  -- WakaTime doesn't require any configuration in Lua
  -- Just having the plugin installed is enough
  -- It will automatically track your coding activity
end

-- Initialize everything
local function setup()
  setup_lsp_servers()
  setup_completion()
  setup_formatting()
  setup_wakatime()
end

setup()
