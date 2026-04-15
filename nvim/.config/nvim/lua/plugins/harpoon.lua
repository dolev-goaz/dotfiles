vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/ThePrimeagen/harpoon",
})
require("harpoon").setup({})
require("telescope").load_extension("harpoon")
vim.keymap.set("n", "<leader>ha", '<cmd>lua require("harpoon.mark").add_file()<CR>', { desc = "[h]arpoon [a]dd file" })
vim.keymap.set("n", "<leader>hs", ":Telescope harpoon marks<CR>", { desc = "[h]arpoon [s]earch files" })

return {}
