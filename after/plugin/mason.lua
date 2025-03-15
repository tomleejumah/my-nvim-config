require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        -- Java
        "jdtls",         -- Java Development Tools Language Server
        -- JavaScript/TypeScript
        "ts_ls",      -- JavaScript/TypeScript
        "eslint",        -- JavaScript/TypeScript linter
        -- Go
        "gopls",         -- Go language server
        -- Python
        "pyright",       -- Python type checking and language server
        "ruff",      -- Python linter and formatter
        -- Web Development
        "html",          -- HTML language server
        "cssls",         -- CSS language server
        "emmet_ls",      -- Emmet completion for HTML/CSS
        -- Rust
        "rust_analyzer", -- Rust language server
        -- Kotlin
        "kotlin_language_server", -- Kotlin language server
        -- Lua
        "lua_ls"
    }
})


