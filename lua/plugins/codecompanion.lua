return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'github/copilot.vim',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
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
  end,
}
