vim.pack.add({
	"https://github.com/rmagatti/auto-session",
})
vim.defer_fn(function()
	require("auto-session").setup({
		auto_create = false,
	})
	vim.keymap.set("n", "<leader>ss", ":AutoSession search<CR>", { desc = "[s]ession [s]earch" })
	vim.keymap.set("n", "<leader>sd", ":AutoSession delete ", { desc = "[s]ession [d]elete" })
	vim.keymap.set("n", "<leader>sr", ":AutoSession restore<CR>", { desc = "[s]ession [r]estore" })
	vim.keymap.set("n", "<leader>sc", ":AutoSession save ", { desc = "[s]ession [c]reate" })
end, 100)

return {}
