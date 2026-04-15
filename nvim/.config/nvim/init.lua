require("set")
require("language")
require("clipboard")
require("floating-terminal")

--- Collect vim.pack plugin paths so lazy preserves them when resetting rtp -------
local pack_paths = vim.tbl_map(function(p)
	return p.path
end, vim.pack.get())

--- lazy(package manager) ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

--- Set up plugins ----------------------------------------------------------------
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	performance = {
		rtp = {
			paths = pack_paths,
		},
		reset_packpath = false,
	},
})

--- Load snippets -----------------------------------------------------------------
for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
	loadfile(path)()
end
