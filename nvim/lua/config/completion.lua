vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.opt.shortmess:append "c"

require('luasnip.loaders.from_vscode').lazy_load()

local lspkind = require "lspkind"
lspkind.init {}

local cmp = require "cmp"
local luasnip = require "luasnip"

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup {
    -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      -- vim.snippet.expand(args.body)
	  require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
	{ name = "luasnip"},
  },
  window = {
  documentation = cmp.config.window.bordered()
  },
  formatting = {
  fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
		local menu_icon = {
		  nvim_lsp = 'λ',
		  luasnip = '⋗',
		  buffer = 'Ω',
		  path = '🖫',
		}

		item.menu = menu_icon[entry.source.name]
		return item
	  end,
  },
  mapping = {
    -- ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    -- ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    -- ["<C-y>"] = cmp.mapping(
    --   cmp.mapping.confirm {
    --     behavior = cmp.ConfirmBehavior.Insert,
    --     select = true,
    --   },
    --   { "i", "c" }
    -- ),
	['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
	['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
	["<C-k>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	end, {'i', 's'}),
	["<C-j>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, {'i', 's'}),
	['<Tab>'] = cmp.mapping(function(fallback)
		local col = vim.fn.col('.') - 1

		if cmp.visible() then
			cmp.select_next_item(select_opts)
		elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
			fallback()
		else
			cmp.complete()
		end
	end, {'i', 's'}),
	['<S-Tab>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item(select_opts)
		else
			fallback()
		end
	end, {'i', 's'}),
  },
}

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = '»'})

vim.diagnostic.config({
  -- virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

-- Setup up vim-dadbod
-- cmp.setup.filetype({ "sql" }, {
--   sources = {
--     { name = "vim-dadbod-completion" },
--     { name = "buffer" },
--   },
-- })

-- ls.config.set_config {
--   history = false,
--   updateevents = "TextChanged,TextChangedI",
-- }

-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
--   -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--   require('lspconfig')['basedpyright'].setup {
--     capabilities = capabilities
-- }
