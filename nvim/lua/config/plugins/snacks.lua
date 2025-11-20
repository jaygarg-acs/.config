-- ~/.config/nvim/lua/plugins/snacks-term.lua
return {
    {
        "folke/snacks.nvim",
        opts = {}, -- default settings are fine
        config = function()
            local snacks = require("snacks")

            -- Helper: get git root of current file or fallback to cwd
            local function git_root_for_current_file()
                local file_dir = vim.fn.expand("%:p:h")
                if file_dir == "" then file_dir = vim.fn.getcwd() end
                local cmd = "git -C " .. vim.fn.fnameescape(file_dir) .. " rev-parse --show-toplevel"
                local out = vim.fn.systemlist(cmd)
                if vim.v.shell_error == 0 and out and out[1] and out[1] ~= "" then
                    return out[1]
                end
                return vim.fn.getcwd()
            end

            -------------------------------------------------------------------------
            -- Quick, disposable floating terminal
            -------------------------------------------------------------------------
            vim.keymap.set("n", "<leader>t", function()
                snacks.terminal.open(nil, {
                    title = "Quick Terminal",
                    border = "rounded",
                    size = { width = 0.88, height = 0.85 },
                    position = "center",
                    cwd = vim.fn.getcwd(),
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                    on_open = function(buf, _)
                        -- Press <Esc> to close
                        -- vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>",
                        -- [[<C-\><C-n>:lua vim.api.nvim_win_close(]] .. win .. [[, true)<CR>]],
                        -- { noremap = true, silent = true })
                        -- Press <leader>y to yank all output
                        vim.keymap.set("t", "<leader>y",
                        [[<C-\><C-n>ggVG"+y:Gitsigns refresh<CR>i]],
                        { buffer = buf, silent = true, desc = "Yank terminal output" })
                    end,
                })
            end, { desc = "Open quick floating terminal" })

            -------------------------------------------------------------------------
            -- LazyGit floating window (repo root)
            -------------------------------------------------------------------------
            vim.keymap.set("n", "<leader>gg", function()
                local cwd = git_root_for_current_file()
                snacks.terminal.open("lazygit", {
                    title = "LazyGit",
                    border = "rounded",
                    size = { width = 0.92, height = 0.92 },
                    position = "center",
                    cwd = cwd,
                    on_open = function(buf, _)
                        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>:close<CR>]],
                        { buffer = buf, silent = true })
                    end,
                })
            end, { desc = "LazyGit (float @ repo root)" })

            -------------------------------------------------------------------------
            -- LazyGit scoped to current file directory
            -------------------------------------------------------------------------
            vim.keymap.set("n", "<leader>gF", function()
                local dir = vim.fn.expand("%:p:h")
                if dir == "" then dir = vim.fn.getcwd() end
                snacks.terminal.open("lazygit", {
                    title = "LazyGit (file dir)",
                    border = "rounded",
                    size = { width = 0.92, height = 0.92 },
                    position = "center",
                    cwd = dir,
                    on_open = function(buf, _)
                        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>:close<CR>]],
                        { buffer = buf, silent = true })
                    end,
                })
            end, { desc = "LazyGit (float @ file dir)" })
        end,
    },
}

