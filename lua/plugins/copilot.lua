local M = {}

function M.setup()
  vim.g.copilot_assume_mapped = true
  vim.keymap.set('i', '<C-l>', 'copilot#Accept("")', { expr = true, silent = true, desc = 'Accept Copilot suggestion' })
end

return M
