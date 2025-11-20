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

                        -- Git branch
                        local branch_name = vim.fn.FugitiveHead()
                        local branch = branch_name ~= '' and (' ' .. branch_name) or ''

                        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
                        local filename    = statusline.section_filename({ trunc_width = 140 })
                        local fileinfo    = statusline.section_fileinfo({ trunc_width = 120 })
                        local location    = statusline.section_location({ trunc_width = 75 })

                        -- 🎥 Recording status: shows only while recording
                        local recording = ''
                        local rec = vim.fn.reg_recording() or ""  -- current macro register
                        if rec ~= '' then
                            recording = ' @' .. rec
                            -- or: recording = 'REC @' .. rec
                        end

                        -- Rose Pine Moon friendly colors
                        vim.api.nvim_set_hl(0, "RecordingHL",        { fg = "#eb6f92", bg = "NONE", bold = true })  -- pink (love)
                        vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo",  { fg = "#f6c177", bg = "NONE", bold = true }) -- gold
                        vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#9ccfd8", bg = "NONE", bold = true }) -- foam cyan

                        return statusline.combine_groups({
                            { hl = mode_hl,                  strings = { mode } },
                            { hl = 'MiniStatuslineDevinfo',  strings = { branch } },
                            { hl = 'MiniStatuslineFilename', strings = { filename } },
                            { hl = 'RecordingHL',          strings = { recording } },

                            -- right align from here
                            { hl = 'MiniStatuslineDevinfo',      strings = { '%=' } },
                            { hl = 'MiniStatuslineFileinfo',     strings = { fileinfo } },
                            { hl = 'MiniStatuslineDiagnostics',  strings = { diagnostics } },
                            { hl = 'MiniStatuslineLocation',     strings = { location } },
                        })
                    end,
                },
            })

            -- mini.pairs
            require('mini.pairs').setup()

            -- 🔁 Force statusline refresh when recording starts/stops
            vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
                callback = function()
                    vim.cmd("redrawstatus")
                end,
            })
        end,
    },
}
