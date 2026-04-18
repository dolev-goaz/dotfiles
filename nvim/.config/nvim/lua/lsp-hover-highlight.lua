-- highlight hovered word and its references
-- NOTE: could use treesitter to not 'flicker' on the same word
local hover_augroup = vim.api.nvim_create_augroup("LSP_reference_highlight", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = hover_augroup,
	desc = "Highlight hovered word and its references",
	callback = function()
		if vim.api.nvim_get_mode().mode ~= "n" then
			return
		end
		vim.lsp.buf.document_highlight()
	end,
})
vim.api.nvim_create_autocmd("CursorMoved", {
	group = hover_augroup,
	desc = "Clear highlighted references when moving cursor",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
