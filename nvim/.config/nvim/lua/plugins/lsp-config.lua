-- Mason
vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
})
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"vtsls",
		"vue_ls",
		"qmlls",
	},
	automatic_enable = false, -- prevent duplicate lsp setup
})

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local telescope = require("telescope.builtin")

			vim.lsp.enable({
				"lua_ls",
				"vtsls",
				"vue_ls",
				"qml_ls",
				"basedpyright",
				"jsonls",
				"clangd",
			})

			-- keymaps
			local function lsp_hover()
				vim.lsp.buf.hover({
					focusable = false,
					max_width = math.floor(vim.o.columns * 0.8),
					border = "rounded",
				})
			end
			vim.keymap.set("n", "K", lsp_hover, { desc = "Hover" })
			vim.keymap.set("n", "<leader>gd", telescope.lsp_definitions, { desc = "[g]o To [d]efinition" })
			vim.keymap.set("n", "<leader>gD", telescope.lsp_type_definitions, { desc = "[g]o To Type [D]efinition" })
			vim.keymap.set("n", "<leader>gi", telescope.lsp_implementations, { desc = "[g]o To [i]mplementation" })
			vim.keymap.set("n", "<leader>gr", telescope.lsp_references, { desc = "[g]o To [r]eferences" })

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ctions" })
		end,
	},
}
