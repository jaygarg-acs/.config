return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufReadPost",
        config = function()
            -- Keep folds available for UFO; respect your foldmethod/foldexpr set in options.lua
            vim.opt.foldcolumn = "0"
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = vim.opt.foldlevelstart:get() -- honor your chosen default (e.g. 0)
            vim.opt.foldenable = true

            local ufo = require("ufo")
            -- Prefer treesitter folds, fall back to indent
            ufo.setup({
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })

            -- Toggle all folds without changing foldlevel
            local folds_open = true
            vim.keymap.set("n", "zA", function()
                if folds_open then
                    ufo.closeAllFolds()
                else
                    ufo.openAllFolds()
                end
                folds_open = not folds_open
            end, { desc = "Toggle all folds (ufo)" })

            -- Preview folded text under cursor
            vim.keymap.set("n", "zP", function()
                ufo.peekFoldedLinesUnderCursor()
            end, { desc = "Peek fold (ufo)" })
        end,
    }
}
