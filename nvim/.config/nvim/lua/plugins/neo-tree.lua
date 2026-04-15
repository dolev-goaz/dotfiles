-- NOTE: requires installing a font from https://www.nerdfonts.com/font-downloads
--       and configuring the terminal (if using fonts for file type)

vim.pack.add({
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/MunifTanjim/nui.nvim",
	-- plugin
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
})
require("neo-tree").setup({
	close_if_last_window = true,
	filesystem = {
		hijack_netrw_behavior = "open_default",
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		filtered_items = {
			always_show = { ".env", ".github" },
		},
	},
	window = {
		position = "right",
	},
})
vim.keymap.set("n", "<C-e>", ":Neotree filesystem toggle<CR>", { silent = true, desc = "Open Directory tree" })

return {}
