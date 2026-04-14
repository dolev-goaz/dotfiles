-- typescript+vue lsp
-- reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue-support
-- https://github.com/vuejs/language-tools/wiki/Neovim

-- placed in after/lsp/ so it loads last in the rtp merge, overriding
-- nvim-lspconfig's lsp/vtsls.lua which omits 'vue' from filetypes.
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

---@type vim.lsp.Config
return {
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
}
