local function can_install_lang(lang)
	local available_langs = require("nvim-treesitter").get_available()
	return vim.tbl_contains(available_langs, lang)
end

local function try_install_lang(lang)
	if not can_install_lang(lang) then
		return false
	end
	local already_installed = require("nvim-treesitter.config").get_installed()
	local is_installed = vim.tbl_contains(already_installed, lang)
	if not is_installed then
		require("nvim-treesitter").install(lang)
	end
	return true
end

---@param langs string[]
local function ensure_installed_langs(langs)
	local already_installed = require("nvim-treesitter.config").get_installed()
	local parsers_to_install = vim.iter(langs)
		:filter(function(parser)
			return not vim.tbl_contains(already_installed, parser)
		end)
		:totable()
	require("nvim-treesitter").install(parsers_to_install)
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	init = function()
		------------------ Ensure installed parsers -----------------
		local default_langs = {
			"lua",
			"typescript",
			"vue",
			"css",
			"scss",
			"markdown",
		}
		ensure_installed_langs(default_langs)

		------------------ Auto install parsers -----------------
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				-- Auto Install
				local lang = vim.treesitter.language.get_lang(ev.match)
				if try_install_lang(lang) then
					vim.treesitter.start()
					require("nvim-treesitter").indentexpr()
				end
			end,
		})
	end,
}
