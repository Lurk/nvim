return {
  'numToStr/Comment.nvim',
  dependecies = {
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true, opts = { enable_autocmd = false } },
  },
  config = function()
    local linecomment = function()
      require('Comment.api').toggle.linewise.count(vim.v.count1)
    end

    vim.keymap.set('n', '<leader>/', linecomment, { desc = '[/] Toggle comment line' })
    vim.keymap.set('v', '<leader>/', '<Esc><Cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { desc = '[/] Toggle comment block' })
  end,
  opts = function(_, opts)
    local commentstring_avail, commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
    if commentstring_avail then
      opts.pre_hook = commentstring.create_pre_hook()
    end
  end,
}
