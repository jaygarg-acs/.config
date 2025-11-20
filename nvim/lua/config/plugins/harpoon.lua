return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                settings = {
                    save_on_change = true,
                    save_on_toggle = true,
                    key = function()
                        -- repo path
                        local cwd = vim.loop.cwd() or ""

                        -- current branch (empty string if not a git repo / detached head)
                        local ok, branch = pcall(function()
                            return vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
                        end)

                        if not ok or not branch or branch == "" then
                            branch = "no-branch"
                        end

                        -- unique storage key: per-repo, per-branch
                        return cwd .. "::" .. branch
                    end,
                },
            })

            -- DO NOT cache the list; always fetch it
            local function list()
                return harpoon:list()
            end

            -- add & menu
            vim.keymap.set("n", "<leader>a", function()
                list():add()
            end, { desc = "Harpoon add file" })

            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(list())
            end, { desc = "Harpoon menu" })

            -- track last/current selected Harpoon index
            local last_idx, curr_idx

            local function goto_idx(i)
                if curr_idx ~= nil then
                    last_idx = curr_idx
                end
                curr_idx = i
                list():select(i)  -- re-fetch list so the current branch key is used
            end

            for i = 1, 9 do
                local idx = i
                vim.keymap.set("n", "<leader>" .. idx, function()
                    goto_idx(idx)
                end, { desc = ("Harpoon go to file %d"):format(idx) })
            end

            vim.keymap.set("n", "<leader><Tab>", function()
                if last_idx then
                    curr_idx, last_idx = last_idx, curr_idx
                    list():select(curr_idx)  -- again, re-fetch list
                else
                    vim.cmd("b#")
                end
            end, { desc = "Harpoon: go to last selected file" })
        end,
    },
}
