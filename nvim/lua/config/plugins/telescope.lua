return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      -- ---------- Setup (smart-case + hidden, skip .git) ----------
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',      -- lowercase → ignore-case; caps → sensitive
            '--hidden',          -- include hidden files
            '--glob', '!.git/*', -- but ignore .git dir
          },
        },
      })

      -- ---------- Safe git-root resolver ----------
      local function repo_root()
        -- 1) Try native upward .git search
        local git_dir = vim.fs.find('.git', { upward = true })[1]
        if git_dir then
          local root = vim.fs.dirname(git_dir)
          if root and vim.loop.fs_stat(root) then
            return root
          end
        end
        -- 2) Fallback to git (handles worktrees)
        local out = vim.fn.systemlist('git rev-parse --show-toplevel')
        if vim.v.shell_error == 0 and out and out[1] and out[1] ~= '' and vim.loop.fs_stat(out[1]) then
          return out[1]
        end
        -- 3) Last resort: current cwd (validated)
        local cwd = vim.loop.cwd()
        if cwd and vim.loop.fs_stat(cwd) then
          return cwd
        end
        return nil
      end

      -- ---------- Safe wrappers that never hard-crash ----------
      local function safe_call(fn, opts, label)
        if vim.fn.executable('rg') ~= 1 then
          return vim.notify('ripgrep (rg) not found in PATH', vim.log.levels.ERROR)
        end
        local root = repo_root()
        if not root then
          return vim.notify('Could not resolve a valid repo root/cwd', vim.log.levels.ERROR)
        end
        opts = vim.tbl_extend('force', { cwd = root }, opts or {})
        local ok, err = pcall(fn, opts)
        if not ok then
          vim.notify((label or 'Telescope') .. ' failed: ' .. tostring(err), vim.log.levels.ERROR)
        end
      end

      -- ---------- Keymaps ----------
      -- Find files (repo root, includes hidden, skips .git)
      vim.keymap.set('n', '<leader>ff', function()
        safe_call(builtin.find_files, { hidden = true }, 'find_files')
      end, { desc = 'Find files (repo root)' })

      -- Resume last Telescope picker
      vim.keymap.set('n', '<leader>fr', function()
        builtin.resume()
      end, { desc = 'Resume last Telescope picker' })

      -- Git files (fallback to find_files if not a git repo)
      vim.keymap.set('n', '<leader>fg', function()
        if vim.fn.executable('git') == 1 then
          local ok = pcall(builtin.git_files, { show_untracked = true })
          if ok then return end
        end
        safe_call(builtin.find_files, { hidden = true }, 'find_files')
      end, { desc = 'Git files (fallback to files)' })

      -- Live grep (repo root, smart-case; prompt first)
      vim.keymap.set('n', '<leader>fs', function()
        local text = vim.fn.input('Grep > ')
        if text == '' then return end
        safe_call(builtin.live_grep, { default_text = text }, 'live_grep')
      end, { desc = 'Live grep (repo root, smart-case)' })

      -- Optional: strict case-insensitive version on <leader>fS
      vim.keymap.set('n', '<leader>fS', function()
        local text = vim.fn.input('Grep (ignore-case) > ')
        if text == '' then return end
        safe_call(builtin.live_grep, {
          default_text = text,
          additional_args = function() return { '--ignore-case' } end,
        }, 'live_grep (ignore-case)')
      end, { desc = 'Live grep (repo root, ignore-case)' })
    end,
  },
}
