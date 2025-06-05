-- Function to get package name 
local function get_package_name()
  local file = vim.fn.expand("%:p") -- Full path of current file
  local cwd = vim.fn.getcwd() -- Project root
  
  -- Get relative path from project root
  local relative_path = file:sub(#cwd + 2) -- Remove cwd + "/"
  
  -- Extract package path between java/ and filename
  local package_path = relative_path:match("java/(.+)/[^/]+%.[^%.]+$")
  if not package_path then
    -- Try kotlin pattern
    package_path = relative_path:match("kotlin/(.+)/[^/]+%.[^%.]+$")
  end
  
  if package_path then
    return package_path:gsub("/", ".")
  end
  
  -- Fallback: scan existing files to learn package structure
  local java_files = vim.fn.globpath(cwd, "**/java/**/*.java", false, true)
  if #java_files == 0 then
    java_files = vim.fn.globpath(cwd, "**/kotlin/**/*.kt", false, true)
  end
  
  if #java_files > 0 then
    local first_file = java_files[1]
    local first_relative = first_file:sub(#cwd + 2)
    local match = first_relative:match("java/(.+)/[^/]+%.[^%.]+$") or 
                  first_relative:match("kotlin/(.+)/[^/]+%.[^%.]+$")
    if match then
      return match:gsub("/", ".")
    end
  end
  
  return "com.example"
end

-- Function to find the source directory (java or kotlin)
local function find_source_directory(lang)
  local cwd = vim.fn.getcwd()
  local patterns = {
    "src/main/" .. lang,
    "src/" .. lang,
    lang,
    "app/src/main/" .. lang, -- Android structure
    "src/main/java", -- Maven/Gradle structure for both java and kotlin
  }
  
  for _, pattern in ipairs(patterns) do
    local full_path = cwd .. "/" .. pattern
    if vim.fn.isdirectory(full_path) == 1 then
      return full_path
    end
  end
  
  -- If no existing directory found, create default Maven structure
  local default_path = cwd .. "/src/main/" .. lang
  return default_path
end

-- Function to move file to correct package directory
local function move_file_to_package(package_name, lang)
  local current_file = vim.fn.expand("%:p")
  local filename = vim.fn.expand("%:t")
  local cwd = vim.fn.getcwd()
  
  -- Find or determine the source directory
  local source_dir = find_source_directory(lang)
  
  -- Convert package name to directory path
  local package_path = package_name:gsub("%.", "/")
  local target_dir = source_dir .. "/" .. package_path
  local target_file = target_dir .. "/" .. filename
  
  -- Create target directory if it doesn't exist
  vim.fn.mkdir(target_dir, "p")
  
  -- Only move if the target is different from current location
  if current_file ~= target_file then
    -- Save current buffer content
    vim.cmd("write")
    
    -- Move the file
    local move_success = vim.fn.rename(current_file, target_file)
    if move_success == 0 then
      -- Close current buffer and open the new file
      vim.cmd("bdelete")
      vim.cmd("edit " .. target_file)
      vim.notify("File moved to: " .. target_file:sub(#cwd + 2), vim.log.levels.INFO)
    else
      vim.notify("Failed to move file to: " .. target_file, vim.log.levels.ERROR)
    end
  end
end

-- Function to load boilerplate template and replace placeholders
local function load_boilerplate(lang, kind, package_name, class_name, should_move_file)
  local template_path = "~/.config/nvim/templates/skel." .. kind .. "." .. lang
  local success, lines = pcall(vim.fn.readfile, vim.fn.expand(template_path))
  if not success then
    vim.notify("Template not found: " .. template_path, vim.log.levels.ERROR)
    return
  end
  
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%%PACKAGE%%", package_name)
                   :gsub("%%FILENAME%%", class_name)
                   :gsub("%%CLASSNAME%%", class_name)
  end
  
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  
  -- Move file to correct package directory if requested
  if should_move_file then
    -- Use vim.schedule to defer the file move until after buffer is set up
    vim.schedule(function()
      move_file_to_package(package_name, lang)
    end)
  end
end

-- Function to load JSX/React template with component name
local function load_jsx_template()
  local filename = vim.fn.expand("%:t:r") -- Get filename without extension
  local component_name = filename:gsub("^%l", string.upper) -- Capitalize first letter
  
  local template_path = "~/.config/nvim/templates/skel.jsx"
  local success, lines = pcall(vim.fn.readfile, vim.fn.expand(template_path))
  if not success then
    vim.notify("Template not found: " .. template_path, vim.log.levels.ERROR)
    return
  end
  
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("${1:ComponentName}", component_name)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

-- Function to load simple template
local function load_simple_template(template_name)
  vim.cmd("0r ~/.config/nvim/templates/" .. template_name)
end

-- Function to prompt for Java/Kotlin boilerplate
local function prompt_java_kotlin_boilerplate(lang)
  vim.ui.select({ "class", "interface", "enum" }, {
    prompt = "Select type for " .. lang .. " file:",
  }, function(choice)
    if not choice then return end
    
    local default_package = get_package_name()
    local current_file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()
    local current_relative = current_file:sub(#cwd + 2)
    
    vim.ui.input({
      prompt = "Package: ",
      default = default_package,
    }, function(package_name)
      if not package_name then return end
      package_name = package_name == "" and "com.example" or package_name
      
      -- Check if package name differs from current location
      local expected_path = package_name:gsub("%.", "/")
      local should_move = not current_relative:find(expected_path, 1, true)
      
      if should_move then
        vim.ui.select({ "Yes", "No" }, {
          prompt = "Package doesn't match current location. Move file to correct directory?",
        }, function(move_choice)
          local class_name = vim.fn.expand("%:t:r") -- Use filename as class name
          load_boilerplate(lang, choice, package_name, class_name, move_choice == "Yes")
        end)
      else
        local class_name = vim.fn.expand("%:t:r") -- Use filename as class name
        load_boilerplate(lang, choice, package_name, class_name, false)
      end
    end)
  end)
end

-- Function to manually move existing file to match package
local function move_to_package()
  local ext = vim.fn.expand("%:e")
  if ext ~= "java" and ext ~= "kt" then
    vim.notify("This function only works with Java/Kotlin files", vim.log.levels.WARN)
    return
  end
  
  -- Extract current package from file content
  local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false) -- Check first 20 lines
  local current_package = ""
  
  for _, line in ipairs(lines) do
    local package_match = line:match("^package%s+([%w%.]+)")
    if package_match then
      current_package = package_match
      break
    end
  end
  
  if current_package == "" then
    vim.notify("No package declaration found in file", vim.log.levels.WARN)
    return
  end
  
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Move file to match package '" .. current_package .. "'?",
  }, function(choice)
    if choice == "Yes" then
      move_file_to_package(current_package, ext)
    end
  end)
end

-- Main function to import boilerplate based on file extension
local function import_boilerplate()
  local ext = vim.fn.expand("%:e")
  local filename = vim.fn.expand("%:t")
  
  -- Check if buffer is empty
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #lines == 1 and lines[1] == ""
  
  if not is_empty then
    vim.notify("Buffer is not empty. Clear it first to import boilerplate.", vim.log.levels.WARN)
    return
  end
  
  -- File extension to template mapping
  local templates = {
    java = function() prompt_java_kotlin_boilerplate("java") end,
    kt = function() prompt_java_kotlin_boilerplate("kt") end,
    html = function() load_simple_template("skel.html") end,
    jsx = function() load_jsx_template() end,
    tsx = function() load_jsx_template() end,
    vue = function() load_simple_template("skel.vue") end,
    svelte = function() load_simple_template("skel.svelte") end,
    ts = function()
      if filename:match("%.component%.ts$") then
        load_simple_template("skel.component.ts")
      else
        vim.notify("No template for .ts files (only .component.ts)", vim.log.levels.INFO)
      end
    end,
    js = function()
      local file_path = vim.fn.expand("%:p")
      if file_path:match("/pages/[^/]+%.js$") then
        load_simple_template("skel.next.js")
      else
        vim.notify("No template for .js files (only pages/*.js)", vim.log.levels.INFO)
      end
    end
  }
  
  if templates[ext] then
    templates[ext]()
  else
    vim.notify("No boilerplate template for ." .. ext .. " files", vim.log.levels.INFO)
  end
end

-- Keymaps
vim.keymap.set("n", "<C-i>", import_boilerplate, { desc = "Import boilerplate template" })
vim.keymap.set("n", "<leader>mp", move_to_package, { desc = "Move file to match package" })
