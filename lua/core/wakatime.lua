local uv = require("luv")

local current_time = ""
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

  local handle, pid =
      uv.spawn(
        "wakatime",
        {
          args = { "--today" },
          stdio = { stdin, stdout, stderr }
        },
        function(code, signal) -- on exit
          stdin:close()
          stdout:close()
          stderr:close()
        end
      )

  uv.read_start(
    stdout,
    function(err, data)
      assert(not err, err)
      if data then
        current_time = "🅆 " .. data:sub(1, #data - 2) .. " "
      end
    end
  )
end

-- Set interval to 5000ms (5 seconds) as requested
set_interval(5000, update_wakatime)

local M = {}
M.get_wakatime = function()
  return current_time
end

return M
