local M = {}

function M.setup()
  require('package-info').setup {
    highlights = {
      up_to_date = {
        fg = '#3C4048',
      },
      outdated = {
        fg = '#d19a66',
      },
      invalid = {
        fg = '#ee4b2b',
      },
    },
    icons = {
      enable = true,
      style = {
        up_to_date = '|  ',
        outdated = '|  ',
      },
    },
    autostart = true,
    hide_up_to_date = false,
    hide_unstable_versions = false,
    package_manager = 'yarn',
  }
end

return M
