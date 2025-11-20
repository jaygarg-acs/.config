return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- 1) Capabilities from nvim-cmp (so LSP completion works in the popup)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { "utf-16" }
        -- 2) Global defaults (optional)
        vim.lsp.config("*", {
            capabilities = capabilities,
            -- You can set root markers, keymaps-on-attach via autocmds, etc.
        })

        -- Bash LSP
        vim.lsp.config("bashls", {
            filetypes = { "sh", "bash" },
            -- Optional: root markers
            root_markers = { ".git", "shell.nix", "package.json" },
            -- Optional: custom settings
            settings = {
                bashIde = {
                    shellcheckPath = "shellcheck",
                    globPattern = "*@(.sh|.inc|.bash|.command)"
                }
            }
        })

        -- 3) Define per-server configs
        vim.lsp.config("basedpyright", {
            -- put per-project settings here if needed
            settings = {
                basedpyright = {
                    analysis = {
                        typeCheckingMode = "basic", -- or "standard" if you prefer
                        reportUnknownVariableType = "none",
                        reportUnknownMemberType = "none",
                        reportUnknownArgumentType = "none",
                        reportUnknownParameterType = "none",
                        reportUnknownLambdaType = "none",
                        reportUnknownArgumentType = "none",
                        reportUnknownAttributeType = "none",
                        reportMissingTypeStubs = "none",
                    },
                },
            },
        })

        -- Ruff is now the LSP (not ruff-lsp); requires Ruff >= 0.5.x
        vim.lsp.config("ruff", {
            init_options = {
                settings = {
                    -- ruff server settings (e.g., logLevel = "info")
                },
            },
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            },
        })

        vim.lsp.config("clangd", {
            cmd = { "clangd", "--background-index", "--clang-tidy" },
            -- If your compile_commands.json lives in build/, you can also set:
            -- root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd" },
        })

        -- 4) Enable them (auto-start when a matching buffer opens)
        vim.lsp.enable({ "basedpyright", "ruff", "lua_ls", "clangd", "bashls" })
    end,
}
--   {
    --     "neovim/nvim-lspconfig",
    --     dependencies = {
        --       {
            --         "folke/lazydev.nvim",
            --         ft = "lua",
            --         opts = {
                --           library = {
                    --             { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    --           },
                    --         },
                    --       },
                    --       -- null-ls is archived; use the maintained fork:
                    --       "nvimtools/none-ls.nvim",
                    --       "nvim-lua/plenary.nvim",
                    --     },
                    --     config = function()
                        --           local util = require("lspconfig.util")
                        --       local capabilities = require("cmp_nvim_lsp").default_capabilities()
                        --
                        --       -- Define servers in a list; each has a string `name`
                        --       local servers = {
                            --         {
                                --           name = "lua_ls",
                                --           cmd = { "lua-language-server" },
                                --           filetypes = { "lua" },
                                --           root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".git"),
                                --           capabilities = capabilities,
                                --           settings = {
                                    --             Lua = {
                                        --               workspace = { checkThirdParty = false },
                                        --               diagnostics = { globals = { "vim" } },
                                        --             },
                                        --           },
                                        --         },
                                        --         {
                                            --           name = "clangd",
                                            --           cmd = { "clangd" },
                                            --           filetypes = { "c", "cpp", "objc", "objcpp" },
                                            --           root_dir = util.root_pattern("compile_commands.json", ".git"),
                                            --           capabilities = capabilities,
                                            --         },
                                            --         {
                                                --           name = "gopls",
                                                --           cmd = { "gopls" },
                                                --           filetypes = { "go", "gomod", "gowork", "gotmpl" },
                                                --           root_dir = util.root_pattern("go.work", "go.mod", ".git"),
                                                --           capabilities = capabilities,
                                                --         },
                                                --         {
                                                    --           name = "basedpyright",
                                                    --           cmd = { "basedpyright-langserver", "--stdio" },
                                                    --           filetypes = { "python" },
                                                    --           root_dir = util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", "requirements.txt", ".git"),
                                                    --           capabilities = capabilities,
                                                    --           settings = {
                                                        --             -- basedpyright uses python.analysis
                                                        --             python = { analysis = { typeCheckingMode = "standard" } },
                                                        --           },
                                                        --         },
                                                        --       }
                                                        --
                                                        --       -- Solid helper: never swaps args, validates name, and autostarts per filetype
                                                        --       local function enable(server)
                                                            --         -- guarantee a string name (fallback to first word of cmd)
                                                            --         local name = server.name or (server.cmd and server.cmd[1]) or "lsp"
                                                            --         server.name = name
                                                            --
                                                            --         local cfg = vim.lsp.config(server)
                                                            --
                                                            --         vim.api.nvim_create_autocmd("FileType", {
                                                                --           pattern = server.filetypes,  -- table or string both OK
                                                                --           callback = function(args)
                                                                    --             local bufnr = args.buf
                                                                    --             -- avoid starting duplicate clients on the buffer
                                                                    --             local already = vim.lsp.get_clients({ bufnr = bufnr, name = name })
                                                                    --             if #already == 0 then
                                                                    --               vim.lsp.start(cfg)
                                                                    --             end
                                                                    --           end,
                                                                    --         })
                                                                    --       end
                                                                    --
                                                                    --       for _, s in ipairs(servers) do
                                                                    --         enable(s)
                                                                    --       end
                                                                    --
                                                                    --       -- Your existing tag-jump keymaps
                                                                    --       vim.keymap.set("n", "]", "<C-]>")
                                                                    --       vim.keymap.set("n", "[", "<C-t>")
                                                                    --
                                                                    --       -- null-ls / none-ls (keep what you had, or use the maintained fork)
                                                                    --       local null_ls = require("null-ls")
                                                                    --       null_ls.setup({
                                                                        --         sources = {
                                                                            --           null_ls.builtins.diagnostics.golangci_lint,
                                                                            --           -- add formatters/linters here
                                                                            --         },
                                                                            --       })
                                                                            --     end
                                                                            --
                                                                            --   },
