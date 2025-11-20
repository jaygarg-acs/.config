vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(args)
        -- 1) Disable semantic tokens to prevent the 2nd color pass / flash
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities and client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
        end
        local bufmap = function(mode, lhs, rhs)
            local opts = {buffer = true}
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Hover
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Definitions (Telescope picker; use <C-v>/<C-x>/<C-t> in the picker for split/vsplit/tab)
        bufmap('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
        -- Quick "back"
        bufmap('n', 'gb', '<C-o>')

        -- Declaration (usually a single jump, keep it direct)
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Implementations (picker)
        bufmap('n', 'gi', '<cmd>Telescope lsp_implementations<cr>')

        -- Type definition (picker)
        bufmap('n', 'go', '<cmd>Telescope lsp_type_definitions<cr>')

        -- References (picker)
        bufmap('n', 'gr', '<cmd>Telescope lsp_references<cr>')

        -- Symbols: file outline & workspace outline (pickers)
        bufmap('n', 'gS', '<cmd>Telescope lsp_document_symbols<cr>')
        bufmap('n', 'gw', '<cmd>Telescope lsp_workspace_symbols<cr>')
        -- Dynamic workspace symbols (updates as you type the query)
        bufmap('n', 'gW', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')

        -- Incoming/Outgoing call graph (great for refactors)
        bufmap('n', 'gI', '<cmd>Telescope lsp_incoming_calls<cr>')
        bufmap('n', 'gO', '<cmd>Telescope lsp_outgoing_calls<cr>')

        -- Signature help (normal + insert)
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        bufmap('i', '<C-s>', function() vim.lsp.buf.signature_help() end)

        -- Rename (atomic, async)
        bufmap('n', 'gR', function() vim.lsp.buf.rename() end)

        -- Code actions (same key for normal/visual; visual gives range actions)
        bufmap({'n','v'}, '<leader>ca', function() vim.lsp.buf.code_action() end)

        -- Format (async)
        bufmap('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)

        -- Diagnostics (float)
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Diagnostics navigation (all severities)
        bufmap('n', 'g[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', 'g]d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
        -- Jump only between **errors**
        bufmap('n', '[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
        bufmap('n', ']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)

        -- Diagnostics pickers (file vs workspace)
        bufmap('n', '<leader>dd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end)
        bufmap('n', '<leader>dD', function() require('telescope.builtin').diagnostics() end)

        -- Toggle inlay hints if supported (great for param/return context)
        bufmap('n', '<leader>ih', function()
            local ok = pcall(function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
            if not ok and vim.lsp.inlay_hint then
                -- Neovim <0.10 fallback API shapes
                local buf = vim.api.nvim_get_current_buf()
                local enabled = vim.lsp.inlay_hint.is_enabled and vim.lsp.inlay_hint.is_enabled(buf) or false
                vim.lsp.inlay_hint(buf, not enabled)
            end
        end)
    end
})
