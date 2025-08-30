local is_copilot_open = false
local function toggle_copilot_chat()
	local copilot_chat = require("CopilotChat")
	if is_copilot_open then
		copilot_chat.close()
	else
		copilot_chat.open()
	end
	is_copilot_open = not is_copilot_open
end
return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken",
		---@type CopilotChat.config.Config
		opts = {
			-- sticky = {
			-- 	"$gpt-4.1",
			-- 	"#filenames:*",
			-- },
			resources = {
				"buffers:visible",
				"selection",
				-- "diagnostics:current",
			},
			tools = {
				"copilot",
			},
		},
		config = function(_, opts)
			require("CopilotChat").setup(opts)
			vim.keymap.set({ "n", "v", "i" }, "<C-c>", toggle_copilot_chat, { desc = "Toggle Copilot Chat" })
		end,
	},
}
