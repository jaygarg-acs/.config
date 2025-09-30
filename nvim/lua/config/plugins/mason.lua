return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"codelldb",
				"gcc",
				"gdb",
			}
		}
	}
}
