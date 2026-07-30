local M = {}

function M.setup()
  require('nvim-treesitter').install {
    'bash',
    'c',
    'html',
    'json',
    'lua',
    'luadoc',
    'markdown',
    'toml',
    'vim',
    'vimdoc',
    'typescript',
    'tsx',
    'javascript',
    'rust',
    'yaml',
  }

  -- The `main` branch only installs parsers; highlighting must be started
  -- explicitly per buffer (the old module system is gone).
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('+treesitter-highlight+', { clear = true }),
    callback = function(ev)
      pcall(vim.treesitter.start, ev.buf)
    end,
  })

  -- Folding driven by treesitter (falls back to no folding on buffers
  -- without an installed parser)
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

return M
