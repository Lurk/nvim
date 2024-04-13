return {
  'okuuva/auto-save.nvim',
  event = { 'InsertLeave', 'TextChanged' },
  opts = {
    noautocmd = true,
    execution_message = {
      enabled = false,
    },
  },
  init = function()
    -- autosave + autoformat on save breaks undo/redo flow. I do not want to give up autosave, so here I am disabling
    -- autoformat on autosave.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveWritePre',
      callback = function()
        vim.g._AUTOFORMAT_ENABLED = vim.g.autoformat_enabled
        vim.g.autoformat_enabled = false
      end,
    })
    -- restore autoformat status after autosave
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveWritePost',
      callback = function()
        vim.g.autoformat_enabled = vim.g._AUTOFORMAT_ENABLED
      end,
    })
  end,
}
