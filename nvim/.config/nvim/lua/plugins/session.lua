return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>sf", ":AutoSession search<CR>", desc = "[s]ession [f]ind" },
		{ "<leader>sd", ":AutoSession delete ", desc = "[s]ession [d]elete" },
		{ "<leader>sr", ":AutoSession restore<CR>", desc = "[s]ession [r]estore" },
		{ "<leader>sc", ":AutoSession save ", desc = "[s]ession [c]reate" },
	},
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		auto_create = false,
		close_filetypes_on_save = { "alpha", "neo-tree", "oil" },
		suppressed_dirs = { "~/", "~/Downloads", "/" },
		session_lens = {
			session_control = {
				pre_save_cmds = {
					function()
						for _, client in ipairs(vim.lsp.get_clients()) do
							client:stop()
						end
					end,
				},
			},
		},
	},
}
