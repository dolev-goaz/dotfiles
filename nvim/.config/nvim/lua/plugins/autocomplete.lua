-- Everything should load on InsertEnter
vim.pack.add({
	"https://github.com/github/copilot.vim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/windwp/nvim-ts-autotag",
})

require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup()

return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "L3MON4D3/LuaSnip", version = "2.*" },
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 150,
				},
				ghost_text = {
					enabled = false,
				},
			},
			signature = {
				enabled = true,
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "lua" },
			-- NOTE: maybe check nvim-cmp for cmdline completion
		},
		opts_extend = { "sources.default" },
	},
}
