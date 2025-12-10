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

