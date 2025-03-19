local uv = require("luv")

local M = {}
M.current_time = "🅆 N/A "

local function set_interval(interval, callback)
  local timer = uv.new_timer()
  local function ontimeout()
    callback(timer)
  end
  uv.timer_start(timer, interval, interval, ontimeout)
  return timer
end

local function update_wakatime()
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  uv.spawn(
    "wakatime",
    {
      args = { "--today" },
      stdio = { stdin, stdout, stderr }
    },
    function(code, signal)
      stdin:close()
      stdout:close()
      stderr:close()
    end
  )

  uv.read_start(stdout, function(err, data)
    if err then
      print("WakaTime error:", err)
      return
    end
    if data then
      -- M.current_time = "🅆 " .. data:gsub("%s+$", "") .. " "
      M.current_time = " " .. data:gsub("%s+$", "") .. " "
    end
  end)
end

update_wakatime()                     -- Run once
set_interval(180000, update_wakatime) -- Update every 3minutes

M.get_wakatime = function()
  return M.current_time
end

return M
