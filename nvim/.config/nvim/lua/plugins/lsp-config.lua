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

			-- typescript+vue lsp
			-- reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue-support
			-- https://github.com/vuejs/language-tools/wiki/Neovim
			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
			local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}
			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								vue_plugin,
							},
						},
					},
				},
				filetypes = tsserver_filetypes,
			})
			-- vue component highlighting
			vim.cmd([[
              highlight link @lsp.type.component @type
            ]])

			-- qml lsp
			vim.lsp.config("qmlls", {
				cmd = { "qmlls", "-I", "/usr/lib/qt6/qml" },
				filetypes = { "qml", "qmljs" },
			})

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				on_attach = function(client, bufnr)
					local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
					if filetype == "vue" and client.name ~= "vue_ls" then
						-- only attach to vue_ls for vue files
						return
					end
					require("nvim-navic").attach(client, bufnr)
				end,
			})

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
