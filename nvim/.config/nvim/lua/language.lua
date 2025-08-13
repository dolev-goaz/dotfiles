vim.opt.termbidi = true -- if terminal supports
function ToggleHebrewEnglish()
	vim.cmd("set rightleft!")
	if vim.bo.keymap == "hebrew" then
		print("Toggled to english")
		vim.bo.keymap = ""
	else
		print("Toggled to hebrew")
		vim.bo.keymap = "hebrew"
	end
end

vim.api.nvim_set_keymap(
	"n",
	"<leader>ll",
	":lua ToggleHebrewEnglish()<CR>",
	{ noremap = true, silent = true, desc = "Toggle Hebrew/English" }
)

------------------------- Language Mapping --------------------------

local langmap_normal = [[אt,בc,גd,דs,הv,וu,זz,חj,טy,יh,כf,לk,מn,נb,סx,עg,פp,צm,קe,רr,שa,ת>]]
local langmap_final = [[ךl,םo,ןi]] .. "," .. [[ף\\;]] .. "," .. [[ץ.]]
local langmap_special = [[\\'w]] .. "," .. "][,[]" .. "," .. [[\\,\\']] -- .. "," .. [[/q]] .. "," .. "./"
local langmap = langmap_normal .. "," .. langmap_final .. "," .. langmap_special

vim.cmd("set langmap=" .. langmap)

-------------------- Keyboard Layout Management --------------------
--- This script manages keyboard layouts.
--- It automatically switches to the US layout when leaving insert mode
--- and restores the last used layout when entering insert mode.

local function get_current_layout_id()
	return vim.fn.system("~/scripts/get-current-layout-id.sh")
end

---@param layout string
local function get_layout_id(layout)
	return vim.fn.system("~/scripts/get-layout-id.sh " .. layout)
end

---@param layout_id string
local function set_layout_id(layout_id)
	vim.fn.system("~/scripts/set-layout-id.sh " .. layout_id)
end

local default_layout_id = get_layout_id("us") -- default to US layout
local buffer_layouts = {}
-- on enter insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local last_layout_id = buffer_layouts[bufnr] or default_layout_id
		set_layout_id(last_layout_id) -- restore the last used layout
	end,
})

-- on leave insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		buffer_layouts[bufnr] = get_current_layout_id()
		set_layout_id(default_layout_id)
	end,
})
