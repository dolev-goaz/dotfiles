return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					merge_duplicates = true,
					max_width = 60,
					stages = "fade_in_slide_out",
					render = "wrapped-default",
					background_colour = "#000000",
					timeout = 3000,
					on_open = function(win)
						vim.api.nvim_win_set_config(win, {
							focusable = false,
						})
					end,
				})
				vim.notify = require("notify")
			end,
		},
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				format = {
					calculator = false,
					-- Hide since we use flash.nvim for search
					search_up = { view = "cmdline" },
					search_down = { view = "cmdline" },
				},
			},
			views = {
				popup = {
					scrollbar = false,
				},
			},
			lsp = {
				hover = {
					enabled = false,
				},
			},
			messages = { enabled = true },
			routes = {
				-- Git status
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "Your branch" },
							{ find = "On branch" },
							{ find = "^Enumerating objects:" },
							{ find = "^Counting objects:" },
							{ find = "^Compressing objects:" },
							{ find = "^Writing objects: " },
							{ find = "^remote: " },
						},
					},
					view = "popup",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "^Saved working directory" },
						},
					},
					view = "notify",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "^fatal:" },
							{ find = "error: failed to push some refs" },
						},
					},
					-- --- @type NoiceNotifyOptions -- remove first two -- for autocomplete
					opts = {
						level = vim.log.levels.ERROR,
						title = "Git Error",
					},
					view = "notify",
				},
				{
					filter = {
						any = {
							{ find = "Toggling hidden files" },
							{ find = "^Restored session:" },
							{ find = "%[LSP%]" }, -- escape square brackets
						},
					},
					view = "mini",
				},
				{
					filter = {
						any = {
							{ find = "^Autoformatting" },
							{ find = "^Inlay Hints" },
						},
					},
					view = "mini",
				},
				-- {
				-- 	filter = {
				-- 		min_height = 8,
				-- 	},
				-- 	view = "popup",
				-- },
			},
		})
		-- Custom print message
		_G.print = function(...)
			local args = { ... }
			local msg = {}
			for i = 1, #args do
				msg[#msg + 1] = vim.inspect(args[i])
			end
			local message = table.concat(msg, " ")
			vim.notify(message, vim.log.levels.INFO, { title = "Print" })
		end
	end,
}
