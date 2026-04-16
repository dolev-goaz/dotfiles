return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			char = {
				---- if we want to disable flash in operator-pending mode(motions)
				-- config = function(opts)
				-- 	local is_operator_pending_mode = vim.fn.mode(true):find("no")
				-- 	-- stop bothering in operator-pending mode
				-- 	opts.autohide = is_operator_pending_mode
				-- 	opts.jump_labels = not is_operator_pending_mode
				--
				-- 	-- remove highlights in operator-pending mode
				-- 	opts.highlight = opts.highlight or {}
				-- 	opts.highlight.backdrop = not is_operator_pending_mode
				-- end,
				jump_labels = true,
			},
			search = {
				enabled = true,
				highlight = { backdrop = true },
			},
		},
	},
	keys = {
	       -- stylua: ignore start
	       { "zf", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	       { "zF", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	       { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	       { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	       { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search", },
		-- stylua: ignore end
	},
	config = function(_, opts)
		require("flash").setup(opts)
		vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#89b4fa", bg = "#313244", bold = true })
		vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ffffff", bg = "#ff007c", bold = true })
	end,
}
