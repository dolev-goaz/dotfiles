vim.filetype.add({
	pattern = {
		[".env%..+"] = "sh",
	},
})
vim.filetype.add({
	extension = {
		rasi = "css",
	},
})
return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		---@module "ibl"
		---@type ibl.config
		opts = {
			enabled = true,
			whitespace = {
				remove_blankline_trail = true,
			},
			scope = {
				enabled = false,
			},
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				filetypes = {
					"vue",
					"html",
					"css",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"lua",
					"qml",
				},
				user_default_options = {
					css = true,
					mode = "virtualtext",
					virtualtext_inline = "before",
				},
			})
		end,
	},
}
