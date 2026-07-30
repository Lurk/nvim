local M = {}

function M.setup()
  require('fidget').setup {
    notification = {
      override_vim_notify = true,
    },
  }
end

return M
