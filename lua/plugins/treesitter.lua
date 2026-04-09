local M = {}

function M.setup()
  require('nvim-treesitter').install {
    'bash',
    'c',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'vim',
    'vimdoc',
    'typescript',
    'javascript',
    'rust',
  }
end

return M
