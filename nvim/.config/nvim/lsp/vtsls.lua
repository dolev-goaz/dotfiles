-- typescript+vue lsp
-- reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue-support
-- https://github.com/vuejs/language-tools/wiki/Neovim

-- NOTE: We call vim.lsp.config() here instead of returning a table.
-- Return values from lsp/*.lua go into rtp_config and are merged first.
-- vim.lsp.config() calls go into _configs[name] which is merged last (wins).
-- This ensures 'vue' is not overwritten by nvim-lspconfig's lsp/vtsls.lua,
-- which only includes the 4 JS/TS filetypes.
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("vtsls", {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
	},
})

return {}
