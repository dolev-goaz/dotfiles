vim.cmd([[
    highlight link @lsp.type.component @type
]])
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

---@type vim.lsp.Config
return {}
