return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local select = require("nvim-treesitter-textobjects.select")
		vim.keymap.set({ "x", "o" }, "af", function()
			select.select_textobject("@function.outer", "textobjects")
		end, { desc = "Select around function" })
		vim.keymap.set({ "x", "o" }, "if", function()
			select.select_textobject("@function.inner", "textobjects")
		end, { desc = "Select inside function" })
		vim.keymap.set({ "x", "o" }, "ac", function()
			select.select_textobject("@class.outer", "textobjects")
		end, { desc = "Select around class" })
		vim.keymap.set({ "x", "o" }, "ic", function()
			select.select_textobject("@class.inner", "textobjects")
		end, { desc = "Select inside class" })
		vim.keymap.set({ "x", "o" }, "al", function()
			select.select_textobject("@loop.outer", "textobjects")
		end, { desc = "Select around loop" })
		vim.keymap.set({ "x", "o" }, "il", function()
			select.select_textobject("@loop.inner", "textobjects")
		end, { desc = "Select inside loop" })

		local move = require("nvim-treesitter-textobjects.move")
		vim.keymap.set({ "n", "x", "o" }, "]f", function()
			move.goto_next_start("@function.outer", "textobjects")
		end, { desc = "Go to next function" })
		vim.keymap.set({ "n", "x", "o" }, "[f", function()
			move.goto_previous_start("@function.outer", "textobjects")
		end, { desc = "Go to previous function" })
		vim.keymap.set({ "n", "x", "o" }, "]c", function()
			move.goto_next_start("@class.outer", "textobjects")
		end, { desc = "Go to next class" })
		vim.keymap.set({ "n", "x", "o" }, "[c", function()
			move.goto_previous_start("@class.outer", "textobjects")
		end, { desc = "Go to previous class" })
		vim.keymap.set({ "n", "x", "o" }, "]l", function()
			move.goto_next_start("@loop.outer", "textobjects")
		end, { desc = "Go to next loop" })
		vim.keymap.set({ "n", "x", "o" }, "[l", function()
			move.goto_previous_start("@loop.outer", "textobjects")
		end, { desc = "Go to previous loop" })
	end,
}
