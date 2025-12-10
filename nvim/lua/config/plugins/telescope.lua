return {
    {
        'nvim-telescope/telescope.nvim',
        --tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },

        config = function()
            local telescope = require('telescope')
            local builtin   = require('telescope.builtin')
            local actions   = require('telescope.actions')

            telescope.setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            preview_height = 0.75,
                        },
                        width  = 0.95,
                        height = 0.95,
                    },
                    path_display = { "truncate" },
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--hidden',
                        '--glob', '!.git/*',
                    },

                    mappings = {
                        i = {
                            -- selection movement
                            ['<C-j>']  = actions.move_selection_next,
                            ['<C-k>']  = actions.move_selection_previous,
                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>']   = actions.move_selection_previous,

                            -- preview scrolling
                            ['<C-d>']      = actions.preview_scrolling_down,
                            ['<C-u>']      = actions.preview_scrolling_up,
                            ['<PageDown>'] = actions.preview_scrolling_down,
                            ['<PageUp>']   = actions.preview_scrolling_up,
                        },
                        n = {
                            -- selection movement
                            ['j']      = actions.move_selection_next,
                            ['k']      = actions.move_selection_previous,
                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>']   = actions.move_selection_previous,

                            -- preview scrolling
                            ['<C-d>']      = actions.preview_scrolling_down,
                            ['<C-u>']      = actions.preview_scrolling_up,
                            ['<PageDown>'] = actions.preview_scrolling_down,
                            ['<PageUp>']   = actions.preview_scrolling_up,
                        },
                    },
                },
            })

            ------------------------------------------------------------------
            -- your repo_root / safe_call / keymaps unchanged below
            ------------------------------------------------------------------

            local function repo_root()
                local git_dir = vim.fs.find('.git', { upward = true })[1]
                if git_dir then
                    local root = vim.fs.dirname(git_dir)
                    if root and vim.loop.fs_stat(root) then
                        return root
                    end
                end
                local out = vim.fn.systemlist('git rev-parse --show-toplevel')
                if vim.v.shell_error == 0 and out and out[1] and out[1] ~= '' and vim.loop.fs_stat(out[1]) then
                    return out[1]
                end
                local cwd = vim.loop.cwd()
                if cwd and vim.loop.fs_stat(cwd) then
                    return cwd
                end
                return nil
            end

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

            vim.keymap.set('n', '<leader>ff', function()
                safe_call(builtin.find_files, { hidden = true }, 'find_files')
            end, { desc = 'Find files (repo root)' })

            vim.keymap.set('n', '<leader>fr', function()
                builtin.resume()
            end, { desc = 'Resume last Telescope picker' })

            vim.keymap.set('n', '<leader>fg', function()
                if vim.fn.executable('git') == 1 then
                    local ok = pcall(builtin.git_files, { show_untracked = true })
                    if ok then return end
                end
                safe_call(builtin.find_files, { hidden = true }, 'find_files')
            end, { desc = 'Git files (fallback to files)' })

            vim.keymap.set('n', '<leader>fs', function()
                local text = vim.fn.input('Grep > ')
                if text == '' then return end
                safe_call(builtin.live_grep, {
                    default_text     = text,
                    sorting_strategy = "ascending",
                    initial_mode     = "normal",
                }, 'live_grep')
            end, { desc = 'Live grep (repo root, smart-case)' })

            vim.keymap.set('n', '<leader>fS', function()
                local text = vim.fn.input('Grep (ignore-case) > ')
                if text == '' then return end
                safe_call(builtin.live_grep, {
                    default_text     = text,
                    additional_args  = function() return { '--ignore-case' } end,
                    sorting_strategy = "ascending",
                    initial_mode     = "normal",
                }, 'live_grep (ignore-case)')
            end, { desc = 'Live grep (repo root, ignore-case)' })
        end,
    },
}
