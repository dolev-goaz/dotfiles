local function is_lsp_supported()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client.server_capabilities.documentHighlightProvider then
			return true
		end
	end
	return false
end
-- highlight hovered word and its references
-- NOTE: could use treesitter to not 'flicker' on the same word
local hover_augroup = vim.api.nvim_create_augroup("LSP_reference_highlight", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = hover_augroup,
	desc = "Highlight hovered word and its references",
	callback = function()
		if vim.api.nvim_get_mode().mode ~= "n" or not is_lsp_supported() then
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
