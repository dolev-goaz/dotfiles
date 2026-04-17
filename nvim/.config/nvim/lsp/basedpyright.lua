---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportMissingTypeStubs = "none",
					reportDeprecated = "none",
					reportUnannotatedClassAttribute = "none",
					reportUnknownVariableType = "none",
					reportMissingParameterType = "none",
					reportUnknownMemberType = "none",
					reportAny = "none",
					reportUnknownArgumentType = "none",
					reportConstantRedefinition = "none",
					reportUnusedCallResult = "none",
					reportUnknownParameterType = "none",
				},
				inlayHints = {
					functionLikeReturnTypes = true,
					callArgumentNames = true,
					genericTypes = true,
				},
			},
		},
	},
}
