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

  -- The `main` branch only installs parsers; highlighting must be started
  -- explicitly per buffer (the old module system is gone).
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('+treesitter-highlight+', { clear = true }),
    callback = function(ev)
      pcall(vim.treesitter.start, ev.buf)
    end,
  })
end

return M
