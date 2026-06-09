return {
    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")

            notify.setup({
                timeout = 5000,
                stages = "fade_in_slide_out",
                render = "default",
            })

            vim.notify = notify

            -- keymap to dismiss notifications
            vim.keymap.set("n", "<leader>nd", function()
                notify.dismiss({ silent = true, pending = true })
            end, { desc = "Dismiss notifications" })
        end,
    }
}
