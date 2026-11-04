local M = {}

function M.setup()
  -- Set by run_with_coverage before a JS/TS coverage run; consumed by the
  -- `results` listener below once neotest reports the run's final (non-partial)
  -- results, since neotest.run.run is async and returns before the run finishes.
  local pending_coverage_reload = false

  local run_all_tests = function()
    require('neotest').run.run { suite = false, vim.fn.expand '%' }
  end

  local debug_current = function()
    require('neotest').run.run { suite = false, strategy = 'dap' }
  end

  local run_with_coverage = function()
    local ft = vim.bo.filetype
    if ft == 'rust' then
      vim.system({ 'cargo', 'llvm-cov', '--lcov', '--output-path', 'target/llvm-cov/lcov.info' }, { text = true }, function(result)
        vim.schedule(function()
          if result.code ~= 0 then
            vim.notify('cargo llvm-cov failed:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
            return
          end
          require('coverage').load_lcov('target/llvm-cov/lcov.info', true)
        end)
      end)
      return
    end
    pending_coverage_reload = true
    require('neotest').run.run {
      suite = false,
      vim.fn.expand '%',
      extra_args = { '--coverage' },
    }
  end

  vim.keymap.set('n', '<leader>dt', debug_current, { desc = '[d]ebug current [t]est' })
  vim.keymap.set('n', '<leader>rt', run_all_tests, { desc = '[r]un all [t]ests in current file' })
  vim.keymap.set('n', '<leader>rc', run_with_coverage, { desc = '[r]un with [c]overage' })

  vim.keymap.set('n', '<leader>cc', function()
    require('coverage').toggle()
  end, { desc = '[c]overage toggle' })

  vim.keymap.set('n', '<leader>cl', function()
    require('coverage').clear()
  end, { desc = '[c]overage c[l]ear' })

  require('neotest').setup {
    adapters = {
      require 'neotest-vitest',
      require 'neotest-jest',
      require 'neotest-rust',
    },
    consumers = {
      coverage_reload = function(client)
        client.listeners.results = function(_, _, partial)
          if partial or not pending_coverage_reload then
            return
          end
          pending_coverage_reload = false
          vim.schedule(function()
            require('coverage').load(true)
          end)
        end
        return {}
      end,
    },
  }
end

return M
