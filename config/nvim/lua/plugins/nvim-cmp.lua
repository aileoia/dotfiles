return {
    "hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- use suggestions from the LSP

		-- Snippet engine. Required for nvim-cmp to work, even if you don't
		-- intend to use custom snippets.
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- adapter for the snippet engine
	},
	config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local select_opts = {behavior = cmp.SelectBehavior.Select}
		cmp.setup({
			-- tell cmp to use Luasnip as our snippet engine
			snippet = {
				expand = function(args) require("luasnip").lsp_expand(args.body) end,
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
                    ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-j>'] = cmp.mapping.select_next_item(select_opts),

                    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({select = true}),
                    ['<CR>'] = cmp.mapping.confirm({select = false}),

                    ['<C-f>'] = cmp.mapping(function(fallback)
                      if luasnip.jumpable(1) then
                        luasnip.jump(1)
                      else
                        fallback()
                      end
                    end, {'i', 's'}),

                    ['<C-b>'] = cmp.mapping(function(fallback)
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
			sources= cmp.config.sources({
				  {name = 'path'},
                  {name = 'nvim_lsp', keyword_length = 1},
                  {name = 'buffer', keyword_length = 3},
                  {name = 'luasnip', keyword_length = 2},
				  }, {
				    { name = 'buffer' },
				  }),
			window = {
                documentation = cmp.config.window.bordered()
                },
})
	end,
}
