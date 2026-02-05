return {
    -- Load all theme plugins but don't apply them
    -- This ensures all colorschemes are available for hot-reloading
    {
        "ribru17/bamboo.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "bjarneo/aether.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "bjarneo/ethereal.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "bjarneo/hackerman.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
    },
    {
        "sainnhe/everforest",
        lazy = true,
        priority = 1000,
    },
    {
        "kepano/flexoki-neovim",
        lazy = true,
        priority = 1000,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "tahayvr/matteblack.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "loctvl842/monokai-pro.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "shaunsingh/nord.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1001,
        config = function()
            -- Truecolor & dark bg recommended
            vim.o.termguicolors = true
            vim.o.background = "dark"

            require("rose-pine").setup({
                variant = "moon",          -- or "main" / "dawn"
                dark_variant = "moon",
                disable_italics = true,    -- <- turn off ALL italics
                -- If you want a transparent background in Neovim, set this:
                -- disable_background = true,
                -- disable_float_background = true,

                -- Optional: make sure common TS groups are non-italic
                highlight_groups = {
                    ["@keyword"]            = { italic = false },
                    ["@function"]           = { italic = false },
                    ["@type"]               = { italic = false },
                    ["@variable"]           = { italic = false },
                    ["@variable.builtin"]   = { italic = false },
                    ["@parameter"]          = { italic = false },
                    Comment                 = { italic = false },
                },
            })

            -- Apply colorscheme
            vim.cmd.colorscheme("rose-pine-moon")

            -- === Telescope tweaks (safe defaults) ===
            local pink  = "#C11C84"
            local black = "#000000"

            vim.api.nvim_set_hl(0, "TelescopeSelection",       { bg = pink,  fg = black })
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret",  { bg = pink,  fg = black })
            vim.api.nvim_set_hl(0, "TelescopeMultiSelection",  { bg = "NONE", fg = black })

            -- Borders: generally only need fg; bg "NONE" avoids blocks
            vim.api.nvim_set_hl(0, "TelescopeBorder",          { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder",    { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeResultsBorder",   { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder",   { fg = pink,  bg = "NONE" })

            vim.api.nvim_set_hl(0, "TelescopeMatching",        { fg = black,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePromptPrefix",    { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeTitle",           { fg = black, bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePreviewTitle",    { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeResultsTitle",    { fg = pink,  bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePromptTitle",     { fg = pink,  bg = "NONE" })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        priority = 1000,
    },
}
