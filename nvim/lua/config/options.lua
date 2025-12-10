--vim.opt.number = true
--vim.opt.relativenumber = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#0D98BA' })
vim.api.nvim_set_hl(0, 'LineNr', { fg='#FF4500' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#0D98BA' })

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shortmess:append("A")

-- Simple, predictable folding powered by Treesitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"  -- requires nvim-treesitter
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"  -- no extra gutter
