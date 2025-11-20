-- git-workflow.lua
-- Clean Neovim Git workflow: Fugitive + Telescope + Diffview + git-conflict
-- - No bracket-style keymaps
-- - gB = fetch → branches (no prune)
-- - gfp = fetch + prune (with 🧹 summary)
-- - gM = merge selected branch (fetch only)
-- - gp = pull
-- - <leader>yp = from either diff side, paste visual selection into result

return {
    ------------------------------------------------------------------------------
    -- Core Git engine
    ------------------------------------------------------------------------------
    {
        'tpope/vim-fugitive',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'sindrets/diffview.nvim',
            'akinsho/git-conflict.nvim',
        },
        config = function()
            local keymap  = vim.keymap.set
            local builtin = require('telescope.builtin')

            ---------------------------------------------------------------------------
            -- Fetch / pull / branches
            ---------------------------------------------------------------------------
            keymap("n", "<leader>gs", vim.cmd.Git, { desc = "Git: status" })
            keymap("n", "<leader>gf", ":Git fetch origin<CR>", { desc = "Git: fetch origin" })
            keymap("n", "<leader>gp", ":Git pull<CR>", { desc = "Git: pull current branch" })

            -- Fetch + prune with summary
            keymap("n", "<leader>gfp", function()
                local before = vim.fn.systemlist("git for-each-ref --format='%(refname:short)' refs/remotes/origin/")
                vim.cmd("Git fetch --prune origin")
                local after = vim.fn.systemlist("git for-each-ref --format='%(refname:short)' refs/remotes/origin/")

                local removed, keep = {}, {}
                for _, r in ipairs(after) do keep[r] = true end
                for _, r in ipairs(before) do if not keep[r] then table.insert(removed, r) end end

                if #removed > 0 then
                    vim.notify(("🧹 Pruned %d stale branches"):format(#removed), vim.log.levels.INFO)
                else
                    vim.notify("✅ No stale branches to prune", vim.log.levels.INFO)
                end
            end, { desc = "Git: fetch+prune origin (with summary)" })

            -- Branch management
            keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git: branches (checkout with Enter)" })
            keymap("n", "<leader>gB", function()
                vim.cmd("Git fetch origin")
                builtin.git_branches()
            end, { desc = "Git: fetch → branches" })

            keymap("n", "<leader>g-", ":Git switch -<CR>", { desc = "Git: previous branch" })

            ---------------------------------------------------------------------------
            -- Merge workflow (fetch only, no prune)
            ---------------------------------------------------------------------------
            keymap("n", "<leader>gM", function()
                builtin.git_branches({
                    prompt_title = "Merge selected branch into current",
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require('telescope.actions')
                        local state   = require('telescope.actions.state')
                        local function do_merge()
                            local entry = state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            if not entry or not entry.value then return end
                            local target = entry.value:gsub("^remotes/", "")
                            vim.cmd("Git fetch origin")
                            vim.cmd("Git merge " .. target)

                            local unmerged = vim.fn.systemlist("git diff --name-only --diff-filter=U")
                            if #unmerged > 0 then
                                vim.cmd("DiffviewOpen --unmerged")
                                vim.notify("Merge has conflicts. Resolve, then :Git commit.", vim.log.levels.WARN)
                            else
                                vim.notify("Merge completed successfully.", vim.log.levels.INFO)
                            end
                        end
                        map('i', '<CR>', do_merge)
                        map('n', '<CR>', do_merge)
                        return true
                    end
                })
            end, { desc = "Git: merge selected branch" })

            ---------------------------------------------------------------------------
            -- Quickfix list of conflicted files (no bracket keys)
            ---------------------------------------------------------------------------
            keymap("n", "<leader>gX", function()
                local files = vim.fn.systemlist("git diff --name-only --diff-filter=U")
                if #files == 0 then
                    vim.notify("No conflicted files.", vim.log.levels.INFO)
                    return
                end
                local items = {}
                for _, f in ipairs(files) do
                    table.insert(items, { filename = f, lnum = 1, col = 1, text = "[conflict]" })
                end
                vim.fn.setqflist({}, ' ', { title = 'Git Conflicts', items = items })
                vim.cmd("copen")
            end, { desc = "Git: open Quickfix with conflicted files" })

            keymap("n", "<leader>qn", ":cnext<CR>",  { desc = "Quickfix: next" })
            keymap("n", "<leader>qp", ":cprev<CR>",  { desc = "Quickfix: previous" })
            keymap("n", "<leader>qc", ":cclose<CR>", { desc = "Quickfix: close" })

            ---------------------------------------------------------------------------
            -- 3-way diff helpers (ours/theirs) + unified partial-line paste
            ---------------------------------------------------------------------------
            keymap("n", "<leader>g3",  ":Gvdiffsplit!<CR>", { desc = "Git: open 3-way diff" })
            keymap("n", "<leader>gq", ":only<CR>", { desc = "Git: close diff splits" })
            -- Helper that only opens Gvdiffsplit if not already diffing
            local function ensure_gvdiffsplit()
                if not vim.wo.diff then
                    vim.cmd("Gvdiffsplit!")
                end
            end

            -- take ours / theirs without re-opening new tabs each time
            vim.keymap.set("n", "<leader>gvo", function()
                ensure_gvdiffsplit()
                vim.cmd("diffget //2")
            end, { desc = "Git: take OURS (reuse existing diff)" })

            vim.keymap.set("n", "<leader>gvt", function()
                ensure_gvdiffsplit()
                vim.cmd("diffget //3")
            end, { desc = "Git: take THEIRS (reuse existing diff)" })

            -- From either side pane (ours/theirs), visually select lines and paste into result
            local function paste_selection_into_result()
                -- yank visual selection into register z
                vim.cmd('normal! "zy')

                -- find the modifiable diff window (result buffer)
                local target_win
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    local is_diff = vim.api.nvim_get_option_value('diff', { win = win })
                    local modifiable = vim.api.nvim_get_option_value('modifiable', { buf = buf })
                    if is_diff and modifiable then
                        target_win = win
                        break
                    end
                end

                if not target_win then
                    vim.notify("Result window not found (is :Gvdiffsplit! open?)", vim.log.levels.ERROR)
                    return
                end

                -- move cursor to result window and paste at cursor
                vim.api.nvim_set_current_win(target_win)
                vim.cmd('normal! "zp')
            end

            keymap('v', '<leader>yp', paste_selection_into_result,
            { desc = "Conflict: paste VISUAL selection from side → result" })

            ---------------------------------------------------------------------------
            -- Diff navigation (no brackets) + Treesitter unmap in diff mode
            ---------------------------------------------------------------------------
            -- Remove Treesitter's [c / ]c only in diff windows (so native hunk jumps work)
            vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
                callback = function()
                    if vim.wo.diff then
                        for _, m in ipairs({ "n", "x", "o" }) do
                            pcall(vim.keymap.del, m, "[c", { buffer = 0 })
                            pcall(vim.keymap.del, m, "]c", { buffer = 0 })
                        end
                        vim.cmd("silent! diffupdate")
                    end
                end,
            })

            -- Leader motions that call native hunk jumps (work only in diff mode)
            local function diff_next()
                if vim.wo.diff then
                    vim.cmd('keepjumps normal! ]c')
                else
                    vim.notify("Not in a diff window (use :Gvdiffsplit! and focus a diff pane).", vim.log.levels.WARN)
                end
            end

            local function diff_prev()
                if vim.wo.diff then
                    vim.cmd('keepjumps normal! [c')
                else
                    vim.notify("Not in a diff window (use :Gvdiffsplit! and focus a diff pane).", vim.log.levels.WARN)
                end
            end

            keymap('n', '<leader>dn', diff_next, { desc = "Diff: next hunk" })
            keymap('n', '<leader>dp', diff_prev, { desc = "Diff: previous hunk" })
        end,
    },

    ------------------------------------------------------------------------------
    -- Diffview: multi-file diffs & history
    ------------------------------------------------------------------------------
    {
        'sindrets/diffview.nvim',
        config = function()
            require('diffview').setup({
                enhanced_diff_hl = true,
                view = { merge_tool = { layout = "diff3_mixed" } },
            })
            local keymap = vim.keymap.set
            keymap("n", "<leader>gD",  ":DiffviewOpen<CR>",              { desc = "Diffview: open repo diff" })
            keymap("n", "<leader>gDu", ":DiffviewOpen --unmerged<CR>",   { desc = "Diffview: conflicted files" })
            keymap("n", "<leader>gDh", ":DiffviewFileHistory %<CR>",     { desc = "Diffview: file history (current)" })
            keymap("n", "<leader>gDH", ":DiffviewFileHistory<CR>",       { desc = "Diffview: repo history" })
            keymap("n", "<leader>gDc", ":DiffviewClose<CR>",             { desc = "Diffview: close" })
        end
    },

    ------------------------------------------------------------------------------
    -- git-conflict.nvim: inline ours/theirs/both/none (no bracket keys)
    ------------------------------------------------------------------------------
    {
        'akinsho/git-conflict.nvim',
        config = function()
            require('git-conflict').setup({
                default_mappings = false,
            })
            local km = vim.keymap.set
            km("n", "<leader>co", "<Plug>(git-conflict-ours)",          { desc = "Conflict: choose OURS" })
            km("n", "<leader>ct", "<Plug>(git-conflict-theirs)",        { desc = "Conflict: choose THEIRS" }) -- note: fix typo if copied
            km("n", "<leader>cb", "<Plug>(git-conflict-both)",          { desc = "Conflict: choose BOTH" })
            km("n", "<leader>c0", "<Plug>(git-conflict-none)",          { desc = "Conflict: choose NONE" })
            km("n", "<leader>cn", "<Plug>(git-conflict-next-conflict)", { desc = "Conflict: next hunk" })
            km("n", "<leader>cp", "<Plug>(git-conflict-prev-conflict)", { desc = "Conflict: previous hunk" })
            km("n", "<leader>cr", function()
                vim.cmd("w")
                vim.cmd("edit!")
                pcall(vim.cmd, "GitConflictRefresh")
                vim.notify("Conflict view refreshed", vim.log.levels.INFO)
            end, { desc = "Conflict: reload file & refresh conflict mode" })

        end
    },
}
