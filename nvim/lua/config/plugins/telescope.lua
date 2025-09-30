return {
	{ 'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} },
	  config = function()
		  local builtin = require('telescope.builtin')
		  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		  vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Telescope find git files' })
		  vim.keymap.set('n', '<leader>fs', function ()
			  builtin.grep_string({ search = vim.fn.input("Grep > ") })
		  end, { desc = 'Telescope grep find files' })
	  end,
  }
	  -- config = function() 
	  --  require('telescope').setup({
	  --   defaults = {
	  -- 	  winblend = 0,
	  -- 	  color_bg = '#FF0000',
	  --   },
	  --   pickers = {
	  -- 	  find_files = {
	  -- 		  theme = "ivy"
	  -- 	  },
	  -- 	  color_bg = '#FF0000'
	  --   }
	  -- })
	  -- end,
}
