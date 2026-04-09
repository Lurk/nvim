local M = {}

function M.setup()
  vim.g.gruvbox_material_background = 'medium'
  vim.g.gruvbox_material_float_style = 'dim'
  vim.cmd.colorscheme 'gruvbox-material'
end

return M
