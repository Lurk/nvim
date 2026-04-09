local M = {}

function M.setup()
  require('telescope').setup {
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  }

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'
  local live_grep = function()
    builtin.live_grep {
      additional_args = { '--no-ignore-vcs' },
    }
  end
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>sa', live_grep, { desc = '[S]earch [A]ll by grep ignoring gitignore' })
  vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = '[S]earch [c]hanged files' })

  vim.keymap.set('n', '<leader>sb', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = 'Fuzzily [s]earch in current [b]uffer' })

  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })

  vim.cmd 'silent! autocmd! FileExplorer *'
  vim.cmd 'autocmd VimEnter * ++once silent! autocmd! FileExplorer *'

  local open_starter_on_dir = function(data)
    if vim.api.nvim_get_current_buf() ~= data.buf then
      return
    end
    if vim.b._processed_dir then
      return vim.api.nvim_buf_delete(data.buf, { force = true })
    end
    local path = vim.api.nvim_buf_get_name(0)
    if vim.fn.isdirectory(path) ~= 1 then
      return
    end

    vim.bo.bufhidden = 'wipe'
    vim.b._processed_dir = true
    vim.schedule(builtin.find_files)
  end

  vim.api.nvim_create_autocmd('BufEnter', { callback = open_starter_on_dir })
end

return M
