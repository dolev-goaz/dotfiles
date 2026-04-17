return {
	"refractalize/oil-git-status.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "stevearc/oil.nvim" },
	},
	config = function()
		require("oil").setup({
			win_options = {
				signcolumn = "yes:2",
			},
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["<BS>"] = "actions.parent",
				["<CR>"] = "actions.select",
				["-"] = false,
				["<C-p>"] = false,
				["<leader>p"] = "actions.preview",
			},
		})
		vim.keymap.set("n", "<C-e>", function()
			if vim.bo.filetype == "oil" then
				require("oil").close()
			else
				require("oil").open()
			end
		end, { desc = "Open Oil" })
		require("oil-git-status").setup({
			show_ignored = false,
			symbols = {
				index = {
					["!"] = "", -- Ignored (Warning icon)
					["?"] = "󰇘", -- Untracked (Ellipsis or question)
					["A"] = "󰐕", -- Added (Plus in a circle or square)
					["C"] = "", -- Copied
					["D"] = "󰆴", -- Deleted (Trash can)
					["M"] = "󰄬", -- Modified (Checkmark for Index/Staged)
					["R"] = "󰑕", -- Renamed
					["T"] = "󰉓", -- Type changed
					["U"] = "󰗖", -- Unmerged (Conflict icon)
					[" "] = " ",
				},
				working_tree = {
					["!"] = "", -- Ignored
					["?"] = "󰇘", -- Untracked
					["A"] = "󰐕", -- Added
					["C"] = "", -- Copied
					["D"] = "󰆴", -- Deleted
					["M"] = "󰏫", -- Modified (Pencil icon for Working Tree)
					["R"] = "󰑕", -- Renamed
					["T"] = "󰉓", -- Type changed
					["U"] = "󰗖", -- Unmerged
					[" "] = " ",
				},
			},
		})
		vim.api.nvim_set_hl(0, "OilGitStatusWorkingTreeModified", { fg = "#ff9e64", bold = true })
		vim.api.nvim_set_hl(0, "OilGitStatusWorkingTreeUntracked", { fg = "#ff7eb6", bold = true })
	end,
}
