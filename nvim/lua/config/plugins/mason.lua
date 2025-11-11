return {
    {
        "williamboman/mason.nvim",
        config = true,
    },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
                "basedpyright",
                "ruff",
                "lua_ls",
				"clangd",
			}
		}
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			ensure_installed = {
				"codelldb",
				"debugpy",
			},
			handlers = {},
		},
	}
}
