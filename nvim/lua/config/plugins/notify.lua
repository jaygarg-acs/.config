return {
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                timeout = 5000,                 -- ⟵ keep popups longer
                stages = "fade_in_slide_out",
                render = "default",
                -- background_colour = "#000000", -- uncomment if transparent bg causes flicker
            })
            vim.notify = require("notify")     -- ensure everyone uses notify
        end,
    }
}
