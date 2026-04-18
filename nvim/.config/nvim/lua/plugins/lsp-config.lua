return {
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
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
		end,
	},
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

			local function toggle_inlay_hints()
				local should_enable = not vim.lsp.inlay_hint.is_enabled()
				vim.lsp.inlay_hint.enable(should_enable)
				if should_enable then
					vim.notify("Inlay Hints Enabled", vim.log.levels.INFO, { title = "LSP" })
				else
					vim.notify("Inlay Hints Disabled", vim.log.levels.INFO, { title = "LSP" })
				end
			end
			local function lsp_hover()
				vim.lsp.buf.hover({
					focusable = false,
					max_width = math.floor(vim.o.columns * 0.8),
					border = "rounded",
				})
			end
			vim.keymap.set("n", "K", lsp_hover, { desc = "Hover" })
			vim.keymap.set("n", "<leader>th", toggle_inlay_hints, { desc = "[t]oggle lsp inlay [h]ints" })
			vim.keymap.set("n", "<leader>gd", telescope.lsp_definitions, { desc = "[g]o To [d]efinition" })
			vim.keymap.set("n", "<leader>gD", telescope.lsp_type_definitions, { desc = "[g]o To Type [D]efinition" })
			vim.keymap.set("n", "<leader>gi", telescope.lsp_implementations, { desc = "[g]o To [i]mplementation" })
			vim.keymap.set("n", "<leader>gr", telescope.lsp_references, { desc = "[g]o To [r]eferences" })

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ctions" })
		end,
	},
}
