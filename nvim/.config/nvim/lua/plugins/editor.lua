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

vim.pack.add({
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/catgoose/nvim-colorizer.lua",
})

require("ibl").setup({
	enabled = true,
	whitespace = {
		remove_blankline_trail = true,
	},
	scope = {
		enabled = false,
	},
})

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

return {}
