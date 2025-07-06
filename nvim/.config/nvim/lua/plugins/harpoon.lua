return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>ha", '<cmd>lua require("harpoon.mark").add_file()<CR>', "[h]arpoon [a]dd file" },
		{ "<leader>hs", ":Telescope harpoon marks<CR>", "[h]arpoon [s]earch files" },
	},
	config = function()
		require("harpoon").setup({})
		require("telescope").load_extension("harpoon")
	end,
}
