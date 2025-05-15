## Java (jdtls) Configuration for cross-platform
This section configures the `jdtls` (Java Development Tools Language Server.Modify /lua/core/lsp.lua) for Neovim, providing robust Java support with features like code completion, navigation, CodeLens, inlay hints, and formatting. The configuration is cross-platform, supporting Windows, macOS, and Linux, with dynamic path detection for Java installations and Lombok.

### Configuration

### Prerequisites and Setup Instructions

-- Prerequisites
-- Neovim: Version 0.9.x or higher.
-- Plugins: neovim/nvim-lspconfig, williamboman/mason.nvim, hrsh7th/cmp-nvim-lsp.
-- Java: JDK 21 (recommended) and optionally JDK 17 installed.
-- Environment Variables (optional):
--   JAVA_HOME: Path to JDK 21.
--   JAVA_17_HOME, JAVA_21_HOME: Paths to specific JDKs.
--   LOMBOK_JAR: Path to Lombok JAR if not using Mason’s default.

-- Setup Instructions
-- Ensure mason.nvim is configured to install jdtls:
require("mason-lspconfig").setup({ ensure_installed = { "jdtls" } })

```lua
-- Java (jdtls) Configuration
local function get_jdtls_paths()
  local java_home = os.getenv("JAVA_HOME") or (
    vim.fn.has("win32") == 1 and "C:\\Program Files\\Java\\jdk-21" or
    vim.fn.has("mac") == 1 and "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home" or
    "/usr/lib/jvm/java-21-openjdk"
  )
  local mason_path = vim.fn.stdpath("data") .. (vim.fn.has("win32") == 1 and "\\mason\\packages\\jdtls" or "/mason/packages/jdtls")
  local lombok_path = os.getenv("LOMBOK_JAR") or (mason_path .. (vim.fn.has("win32") == 1 and "\\lombok.jar" or "/lombok.jar"))
  local config_dir = mason_path .. (
    vim.fn.has("win32") == 1 and "\\config_win" or
    vim.fn.has("mac") == 1 and "/config_mac" or
    "/config_linux"
  )
  local data_dir = (vim.fn.stdpath("cache") .. (vim.fn.has("win32") == 1 and "\\jdtls-workspace\\" or "/jdtls-workspace/")) .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  return java_home, lombok_path, config_dir, data_dir
end

local java_home, lombok_path, config_dir, data_dir = get_jdtls_paths()
local java_17_path = os.getenv("JAVA_17_HOME") or (
  vim.fn.has("win32") == 1 and "C:\\Program Files\\Java\\jdk-17" or
  vim.fn.has("mac") == 1 and "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home" or
  "/usr/lib/jvm/java-17-openjdk"
)
local java_21_path = os.getenv("JAVA_21_HOME") or (
  vim.fn.has("win32") == 1 and "C:\\Program Files\\Java\\jdk-21" or
  vim.fn.has("mac") == 1 and "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home" or
  "/usr/lib/jvm/java-21-openjdk"
)

lspconfig.jdtls.setup({
  cmd = {
    java_home .. (vim.fn.has("win32") == 1 and "\\bin\\java.exe" or "/bin/java"),
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombok_path,
    '-jar', vim.fn.glob(mason_path .. (vim.fn.has("win32") == 1 and "\\plugins\\org.eclipse.equinox.launcher_*.jar" or "/plugins/org.eclipse.equinox.launcher_*.jar")),
    '-configuration', config_dir,
    '-data', data_dir,
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
          { name = "JavaSE-17", path = java_17_path, default = true },
          { name = "JavaSE-21", path = java_21_path },
        },
      },
    },
  },
  init_options = { bundles = {} },
  on_attach = on_attach,
  capabilities = capabilities,
})
