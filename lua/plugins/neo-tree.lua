local M = {}

function M.setup()
  vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle<CR>', { desc = '[t]oggle Explorer' })
  vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

  require('neo-tree').setup {
    close_if_last_window = true,
    window = {
      auto_expand_width = true,
    },
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = vim.fn.has 'win32' ~= 1,
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = '',
          modified = '',
          deleted = '✖',
          renamed = '󰁕',
          untracked = '★',
          ignored = '◌',
          unstaged = '✗',
          staged = '✓',
          conflict = '',
        },
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  }
end

return M
