vim.pack.add({ "https://github.com/folke/which-key.nvim" }, {
	load = function()
		local which_key = require("which-key")
		which_key.setup({})
		which_key.add({
			{ "<leader>o", group = "Open" },
			{ "<leader>og", group = "Open Git" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>tg", group = "Toggle Git" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Go To" },
			{ "<leader>l", group = "Language" },
			{ "<leader>c", group = "Code" },
			{ "<leader>cd", group = "Code Diagnostics" },
			{ "<leader>s", group = "Session" },
		})
		vim.keymap.set("n", "<leader>?", ":WhichKey<CR>", { desc = "Buffer Local Keymaps (which-key)" })
	end,
})

return {}
