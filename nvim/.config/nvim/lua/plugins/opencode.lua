return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- provider = {
				-- 	enabled = "wezterm",
				-- 	wezterm = {
				-- 		direction = "right",
				-- 	},
				-- },
			}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			vim.keymap.set({ "n", "t" }, "<C-c><C-c>", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })
			vim.keymap.set({ "n", "x" }, "<C-c><C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask opencode" })
			vim.keymap.set({ "n", "x" }, "<C-c><C-x>", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
			-- vim.keymap.set({ "n", "x" }, "ga", function()
			-- 	require("opencode").prompt("@this")
			-- end, { desc = "Add to opencode" })
			vim.keymap.set("n", "<C-c><C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "opencode half page up" })
			vim.keymap.set("n", "<C-c><C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "opencode half page down" })
			-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},
}
