local M = {}

function M.setup()
  require('coverage').setup { auto_reload = true }
end

return M
