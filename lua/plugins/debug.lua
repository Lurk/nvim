local M = {}

function M.setup()
  local dap = require 'dap'
  local dapui = require 'dapui'

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'green', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'green', linehl = '', numhl = '' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'red', linehl = '', numhl = '' })

  require('dap').adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'js-debug-adapter',
      args = { '${port}' },
    },
  }

  for _, language in ipairs { 'typescript', 'javascript' } do
    require('dap').configurations[language] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }
  end

  require('mason-nvim-dap').setup {
    automatic_setup = true,
    handlers = {},
    ensure_installed = {
      'js',
      'rust',
    },
  }

  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
  vim.keymap.set('n', '<leader>dB', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = '[D]ebug: Set [B]reakpoint' })

  dapui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close
end

return M
