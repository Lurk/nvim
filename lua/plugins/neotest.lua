return {
  'nvim-neotest/neotest',
  ft = { 'typescript', 'rust', 'javascript' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-jest',
    'rouge8/neotest-rust',
  },
  config = function()
    local run_all_tests = function()
      require('neotest').run.run { suite = false, vim.fn.expand '%' }
    end

    local debug_current = function()
      require('neotest').run.run { suite = false, strategy = 'dap' }
    end

    vim.keymap.set('n', '<leader>dt', debug_current, { desc = '[D]ebug current [t]est' })
    vim.keymap.set('n', '<leader>rt', run_all_tests, { desc = '[r]un all [t]ests in current file' })

    require('neotest').setup {
      adapters = {
        require 'neotest-jest',
        require 'neotest-rust',
      },
    }
  end,
}
