vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
})
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 100,
	},
})

vim.keymap.set("n", "<leader>ogp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "[o]pen [g]it [p]review" })
vim.keymap.set("n", "<leader>tgb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "[t]oggle [g]it [b]lame" })
vim.keymap.set("n", "<leader>ogl", "<cmd>Telescope git_commits<CR>", { desc = "[o]pen [g]it [l]ogs" })
vim.keymap.set(
	"n",
	"<leader>oglb",
	"<cmd>Telescope git_bcommits<CR>",
	{ desc = "[o]pen [g]it [l]ogs current [b]uffer" }
)
vim.keymap.set("n", "<leader>ogs", "<cmd>Telescope git_stash<CR>", { desc = "[o]pen [g]it [s]tash" })

return {}
