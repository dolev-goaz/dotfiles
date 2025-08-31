return {
	"rmagatti/auto-session",
	event = "VeryLazy",
	keys = {
		{ "<leader>sf", ":AutoSession search<CR>", desc = "[s]ession [f]ind" },
		{ "<leader>sd", ":AutoSession delete ", desc = "[s]ession [d]elete" },
		{ "<leader>sr", ":AutoSession restore<CR>", desc = "[s]ession [r]estore" },
		{ "<leader>sc", ":AutoSession save ", desc = "[s]ession [c]reate" },
	},
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		auto_create = false,
	},
}
