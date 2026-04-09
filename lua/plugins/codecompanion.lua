local M = {}

function M.setup()
  local cc = require 'codecompanion'
  cc.setup {
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    },
  }
  vim.keymap.set('n', '<leader>cc', function()
    cc.toggle()
  end, { desc = 'Code Companion Chat' })
  vim.keymap.set('n', '<leader>ca', function()
    cc.actions()
  end, { desc = 'Code Companion Action' })
end

return M
