return {
	"SmiteshP/nvim-navic",
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client or not client.server_capabilities.documentSymbolProvider then
					return
				end
				local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
				if filetype == "vue" and client.name ~= "vue_ls" then
					return
				end

				local bufnr = args.buf
				require("nvim-navic").attach(client, bufnr)
			end,
		})
	end,
}
