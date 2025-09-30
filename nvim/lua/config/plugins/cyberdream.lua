return {
	{ "scottmckendry/cyberdream.nvim",
	  config = function() 
		  require("cyberdream").setup({
			  transparent = true,
			  extensions = {
				  telescope = true,
				  treesitter = true,
			  },
			  -- highlights = {
				  --  NormalFloat = { fg = '#FFFFFF', bg = 'pink' },
				  --  FloatBorder = { bg = 'pink'},
				  -- },
			  })
			  vim.cmd('colorscheme cyberdream')
			  color = color or "cyberdream"--"tokyodark"--"dracula"

				vim.cmd.colorscheme(color)
				pink = "#C11C84"
				black = "black"
				vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = pink, fg = black })
				vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = pink, fg = black})
				vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { bg = "none", fg = black})
				--vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" , fg = black})
				--vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none", fg = pink })
				vim.api.nvim_set_hl(0, "TelescopeResultsClass", { bg = "none", fg = pink })
				vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = pink, fg = black })
				vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" , fg = pink })
				vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none", fg = pink })
				vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
				vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none", fg = pink })
				vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = pink, fg = red })
				vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "none"})
				vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = black })
				vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = pink })
				vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = pink })
				vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = pink })
		  end
	  }
}
