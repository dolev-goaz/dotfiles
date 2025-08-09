require("set")
require("clipboard")
require("floating-terminal")

-- lazy(package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

--- Set up plugins ----------------------------------------------------------------
require("lazy").setup("plugins")

--- Load snippets -----------------------------------------------------------------
for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
	loadfile(path)()
end
