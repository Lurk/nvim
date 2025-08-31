return {
  'github/copilot.vim',
  lazy = false, -- lazy loading
  config = function()
    vim.g.copilot_assume_mapped = true
  end,
}
