-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: For more options, you can see `:help option-list`

-- More colors
vim.opt.termguicolors = true

-- How wide I can get
vim.opt.colorcolumn = '120'

-- Enable spell checker
vim.opt.spell = true
vim.opt.spelloptions = 'camel'
vim.opt.spelllang = 'en_us'

-- Make line numbers default
vim.opt.number = true

-- You can also add relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Folding (foldmethod/foldexpr set in lua/plugins/treesitter.lua)
vim.opt.foldlevelstart = 99 -- start with all folds open

-- Fold text: first line + closing line of the fold, e.g. `"question": {...}`
function _G.FoldText()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.trim(vim.fn.getline(vim.v.foldend))
  return start_line .. '...' .. end_line
end
vim.opt.foldtext = 'v:lua.FoldText()'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = '·' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [e]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- misc
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite current buffer' })
vim.keymap.set('n', '<leader>pu', function()
  vim.pack.update()
end, { desc = '[p]ack [u]pdate' })
vim.keymap.set('n', '<leader>/', ':normal gcc<CR><DOWN>', { desc = '[/] Toggle comment line' })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, desc = 'Redo' })
-- <Esc> - exists visual mode.
-- :normal executes keystrokes in normal mode.
-- gv - restores selection.
-- gc - toggles comment
-- <CR> sends the command
vim.keymap.set('v', '<leader>/', '<Esc>:normal gvgc<CR>', { desc = '[/] Toggle comment block' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('+highlight-yank+', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Autosaves current buffer
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'VimLeavePre' }, {
  desc = 'Autosaves current buffer',
  group = vim.api.nvim_create_augroup('+autosave+', {}),
  callback = function(event)
    if vim.api.nvim_get_option_value('buftype', { buf = event.buf }) == '' and vim.api.nvim_get_option_value('modified', { buf = event.buf }) then
      vim.api.nvim_buf_call(event.buf, function()
        vim.cmd 'silent! write'
      end)
    end
  end,
})

vim.filetype.add {
  extension = {
    yamd = 'markdown',
    html = 'htmldjango',
  },
}

-- [[ Build hooks — must be registered before vim.pack.add() ]]
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end

    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
  end,
})

-- [[ Install plugins ]]
local specs = {
  -- Colorscheme (must be first)
  'https://github.com/sainnhe/gruvbox-material',

  -- Core
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',

  -- LSP ecosystem
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range '>=9.0.0 <10.0.0' },
  'https://github.com/folke/lazydev.nvim',

  -- Editing
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- mini
  'https://github.com/nvim-mini/mini.nvim',

  -- UI
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'master' },
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },

  -- Terminal
  'https://github.com/akinsho/toggleterm.nvim',

  -- Debug
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',

  -- Testing
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/marilari88/neotest-vitest',
  'https://github.com/rouge8/neotest-rust',

  -- Language-specific
  { src = 'https://github.com/saecki/crates.nvim', version = 'stable' },
  'https://github.com/vuki656/package-info.nvim',

  -- AI
  'https://github.com/github/copilot.vim',
  'https://github.com/olimorris/codecompanion.nvim',
}

-- Conditional plugins
if vim.fn.executable 'make' == 1 then
  table.insert(specs, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim')
end

vim.pack.add(specs)

-- [[ Configure plugins ]]
require('plugins.gruvbox-material').setup()
require('plugins.fidget').setup()
require('plugins.treesitter').setup()
require('plugins.mini').setup()
require('plugins.telescope').setup()
require('plugins.conform').setup()
require('plugins.lsp').setup()
require('plugins.gitsigns').setup()
require('plugins.neo-tree').setup()
require('plugins.toggleterm').setup()
require('plugins.debug').setup()
require('plugins.neotest').setup()
require('plugins.crates').setup()
require('plugins.package-info').setup()
require('plugins.copilot').setup()
require('plugins.codecompanion').setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
