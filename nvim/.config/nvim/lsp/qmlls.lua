---@type vim.lsp.Config
return {
	cmd = { "qmlls", "-I", "/usr/lib/qt6/qml" },
	filetypes = { "qml", "qmljs" },
}
