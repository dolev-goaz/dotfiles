return {
	"andymass/vim-matchup",
	event = "BufReadPost",
	---@type matchup.Config
	opts = {
		treesitter = {
			stopline = 500,
		},
	},
}
