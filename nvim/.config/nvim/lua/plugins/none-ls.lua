local function check_installed(package_name, installed_packages)
	for _, value in pairs(installed_packages) do
		if value == package_name then
			return true
		end
	end
	return false
end
local function ensure_installed(package_name, installed_packages_names)
	if check_installed(package_name, installed_packages_names) then
		return true
	end
	vim.notify(
		string.format("Package %s is not installed. Please install it using Mason.", package_name),
		vim.log.levels.WARN
	)
	return false
end

vim.pack.add({
	-- dependencies
	"https://github.com/nvimtools/none-ls-extras.nvim",
	"https://github.com/esmuellert/nvim-eslint",
	-- plugin
	"https://github.com/nvimtools/none-ls.nvim",
})

local null_ls = require("null-ls")
local installed_packages = require("mason-registry").get_installed_package_names()
local sources = {}
if ensure_installed("prettier", installed_packages) then
	table.insert(sources, null_ls.builtins.formatting.prettier)
end
if ensure_installed("stylua", installed_packages) then
	table.insert(sources, null_ls.builtins.formatting.stylua)
end
if check_installed("shfmt", installed_packages) then
	table.insert(sources, null_ls.builtins.formatting.shfmt)
end
if check_installed("latexindent", installed_packages) then
	table.insert(sources, require("none-ls.formatting.latexindent"))
end

null_ls.setup({ sources = sources })
require("utils.format")

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	float = {
		focusable = false,
		border = "rounded",
		max_width = 60,
	},
})
vim.keymap.set("n", "<leader>cdl", require("telescope.builtin").diagnostics, { desc = "[c]ode [d]iagnostics [l]ist" })
vim.keymap.set("n", "<leader>cdc", vim.diagnostic.open_float, { desc = "[c]ode [d]iagnostics [c]urrent" })
return {}
