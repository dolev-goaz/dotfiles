local function ensure_ripgrep()
	local has_rg = vim.fn.executable("rg") == 1
	if has_rg then
		return
	end

	vim.notify("ripgrep not found. On linux, try:\nsudo apt install ripgrep")
end
ensure_ripgrep()

vim.pack.add({
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	-- plugins
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/nvim-telescope/telescope-project.nvim",
})

vim.defer_fn(function()
	require("telescope").setup({
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
		pickers = {
			live_grep = {
				file_ignore_patterns = {
					"node_modules",
					".git/",
					"dist",
				},
				additional_args = function()
					return { "--hidden" }
				end,
			},
		},
	})
	require("telescope").load_extension("ui-select")
	require("telescope").load_extension("project")
	vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>", { desc = "Telescope: Search Git files" })
	vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[f]ind [f]iles" })
	vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "[f]ind [g]rep Search" })
	vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[f]ind [h]elp" })
end, 100)

return {}
