return {
    {
        'echasnovski/mini.nvim',
        enabled = true,
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup({
                use_icons = true,
                content = {
                    active = function()
                        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                        local branch = vim.fn.FugitiveHead()
                        local git = (branch ~= '' and (' ' .. branch)) or ''
                        local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
                        local filename      = statusline.section_filename({ trunc_width = 140 })
                        local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
                        local location      = statusline.section_location({ trunc_width = 75 })

                        local branch = git ~= '' and (' ' .. git) or ''
                        return statusline.combine_groups({
                            { hl = mode_hl,                  strings = { mode } },
                            { hl = 'MiniStatuslineDevinfo',  strings = { branch } },
                            { hl = 'MiniStatuslineFilename', strings = { filename } },

                            -- right align from here
                            { hl = 'MiniStatuslineDevinfo',  strings = { '%=' } },
                            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                            { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics } },
                            { hl = 'MiniStatuslineLocation', strings = { location } },
                        })
                    end
                }
            })
            local pairs = require('mini.pairs').setup()
        end
    },
}
