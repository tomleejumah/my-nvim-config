-- LSP Configuration
local lspconfig = require('lspconfig')

-- LSP Attach Function with Keybindings
local on_attach = function(client, bufnr)
  -- Mappings
  vim.keymap.set("n", "gd", vim.lsp.buf.definition,
    { buffer = bufnr, silent = true, noremap = true, desc = "Go to definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
    { buffer = bufnr, silent = true, noremap = true, desc = "Go to declaration" })
  vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
    { buffer = bufnr, silent = true, noremap = true, desc = "List references" })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
    { buffer = bufnr, silent = true, noremap = true, desc = "Go to type definition" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover,
    { buffer = bufnr, silent = true, noremap = true, desc = "Show hover documentation" })
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
    { buffer = bufnr, silent = true, noremap = true, desc = "Show signature help" })
  vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help,
    { buffer = bufnr, silent = true, noremap = true, desc = "Show signature help" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
    { buffer = bufnr, silent = true, noremap = true, desc = "Code actions" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
    { buffer = bufnr, silent = true, noremap = true, desc = "Rename symbol" })
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
    { buffer = bufnr, silent = true, noremap = true, desc = "Add workspace folder" })
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
    { buffer = bufnr, silent = true, noremap = true, desc = "Remove workspace folder" })
  vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run,
    { buffer = bufnr, silent = true, noremap = true, desc = "Run CodeLens action" })

  -- Always enable and refresh CodeLens for all language servers
  -- This will refresh CodeLens even for servers that don't explicitly declare support
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = function()
      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh()
      end
    end,
  })
end

-- Set up custom CodeLens styling (VS Code/JetBrains style)
vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#777777", italic = true })
vim.api.nvim_set_hl(0, "LspCodeLensText", { fg = "#777777", italic = true })
vim.api.nvim_set_hl(0, "LspCodeLensRefText", { fg = "#777777", italic = true })
vim.api.nvim_set_hl(0, "LspCodeLensRefIcon", { fg = "#777777", italic = true })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = "#777777", italic = true })

-- Setup diagnostic signs
local signs = { Error = "✗", Warn = "!", Hint = "➤", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = "● " },
  float = { source = "always", border = "rounded" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Get LSP capabilities with CodeLens explicitly enabled
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.codeLens = { dynamicRegistration = false }

-- Enable global CodeLens
vim.g.codelens_enabled = true

-- Enhanced JavaScript/TypeScript Configuration
lspconfig.ts_ls.setup({
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
  root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git"),
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
          target = "17",
        },
      },
      inlayHints = { enable = true },
      references = { includeDecompiledSources = true },
      codeLens = { enable = true },
    },
  },
})

-- Java (jdtls) Configuration
lspconfig.jdtls.setup({
  cmd = {
    (os.getenv("JAVA_HOME") or "/usr/lib/jvm/java-21-openjdk") .. "/bin/java",
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. (os.getenv("LOMBOK_JAR") or vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/lombok.jar')),
    '-jar', vim.fn.glob(vim.fn.expand(
    '~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')),
    '-configuration', vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/config_linux'),
    '-data', vim.fn.expand('~/.cache/jdtls-workspace/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },
  root_dir = lspconfig.util.root_pattern('pom.xml', 'build.gradle', 'gradlew', 'mvnw', '.git'),
  settings = {
    java = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      format = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      configuration = {
        runtimes = {
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk", default = true },
          { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
        },
      },
    },
  },
  init_options = { bundles = {} },
  on_attach = on_attach,
  capabilities = capabilities,
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
  root_dir = lspconfig.util.root_pattern("pyproject.toml", "ruff.toml", ".git"),
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
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
  filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
})

-- Rust
require("rust-tools").setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        imports = { granularity = { group = "module" }, prefix = "self" },
        lens = {
          enable = true,
          methodReferences = true,
          references = true,
          implementations = true,
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
  root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
  settings = {
    intelephense = {
      references = { includeDecompiledSources = true },
      telemetry = { enabled = false },
      codeLens = { enable = true },
    },
  },
})

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      codeLens = { enable = true },
    },
  },
})

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
      ["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
  })
end

-- Setup format on save
local function setup_formatting()
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
      xml = { "xmllint", "prettier" },
      css = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end

-- Function to setup CodeLens commands
local function setup_codelens_commands()
  -- Setup global autocommand for CodeLens refresh
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
    pattern = "*",
    callback = function()
      vim.lsp.codelens.refresh()
    end,
  })

  -- Enable CodeLens auto-refresh when cursor is moved
  vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          break
        end
      end
    end,
    desc = "Auto-refresh CodeLens when cursor is moved",
  })
end

-- Initialize everything
local function setup()
  setup_completion()
  setup_formatting()
  setup_codelens_commands()
end

setup()
