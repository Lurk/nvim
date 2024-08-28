return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  build = 'make', -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
  opts = {
    provider = 'copilot',
  },
  dependencies = {
    'echasnovski/mini.icons',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below is optional, make sure to setup it properly if you have lazy=true
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
