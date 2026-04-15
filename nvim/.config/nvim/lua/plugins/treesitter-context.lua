vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" }, {
	load = function()
		vim.api.nvim_create_autocmd({ "BufRead", "BufReadPre" }, {
			once = true,
			callback = function()
				require("treesitter-context").setup({})
			end,
		})
	end,
})
return {}
