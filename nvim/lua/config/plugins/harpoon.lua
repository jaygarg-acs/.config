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
                    mark_branch = true, -- set true if you want per-branch lists
                },
            })

            local list = harpoon:list()

            -- add & menu
            vim.keymap.set("n", "<leader>a", function() list:add() end, { desc = "Harpoon add file" })
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(list) end, { desc = "Harpoon menu" })

            -- track last/current selected Harpoon index
            local last_idx, curr_idx
            local function goto_idx(i)
                if curr_idx ~= nil then last_idx = curr_idx end
                curr_idx = i
                list:select(i)
            end

            -- FIX: capture i per-iteration
            for i = 1, 9 do
                local idx = i
                vim.keymap.set("n", "<leader>" .. idx, function()
                    goto_idx(idx)
                end, { desc = ("Harpoon go to file %d"):format(idx) })
            end
            vim.keymap.set("n", "<leader><Tab>", function()
            if last_idx then
                curr_idx, last_idx = last_idx, curr_idx
                list:select(curr_idx)
            else
                vim.cmd("b#")
            end
            end, { desc = "Harpoon: go to last selected file" })
        end,
    },
}
