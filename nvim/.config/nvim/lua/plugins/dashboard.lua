local function reload_lazy()
	-- close Lazy and re-open when the dashboard is ready
	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "AlphaReady",
			callback = function()
				require("lazy").show()
			end,
		})
	end
end

vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/goolord/alpha-nvim",
})

local function create_dashboard()
	local dashboard = require("alpha.themes.dashboard")
	local dashboard_utils = require("utils.dashboard")

	dashboard.section.header.val = dashboard_utils.headers.ghost
	dashboard.section.header.opts.hl = "DashboardHeader"

	dashboard.section.buttons.val = dashboard_utils.buttons

	dashboard.section.footer.val = dashboard_utils.generate_footer()
	dashboard.section.footer.opts.hl = "DashboardHeader"

	local greeting_section = dashboard_utils.create_text_section({ content = dashboard_utils.generate_greeting() })

	-- NOTE: only relevant if using lazy.nvim
	local plugin_stats_section = dashboard_utils.create_text_section({
		content = dashboard_utils.add_border_block(dashboard_utils.get_plugin_stats({ loading = true })),
		hl = "DashboardHeader",
	})

	local section = {
		header = dashboard.section.header,
		buttons = dashboard.section.buttons,
		greeting = greeting_section,
		plugins = plugin_stats_section,
		footer = dashboard.section.footer,
	}

	reload_lazy()

	local function get_vertical_align_padding()
		local total_content_height = dashboard_utils.get_section_text_height(section.header)
			+ 2 * dashboard_utils.get_section_text_height(section.buttons) -- buttons have one-line spacing
			+ dashboard_utils.get_section_text_height(section.greeting)
			+ 2 -- greeting + footer
			+ 4 -- spacing between sections
		local total_window_height = vim.fn.winheight(0) - 2 -- lualine and statusline
		return math.max(0, math.floor((total_window_height - total_content_height) / 2))
	end

	local opts = {
		layout = {
			{ type = "padding", val = get_vertical_align_padding() },
			section.header,
			{ type = "padding", val = 2 },
			section.buttons,
			section.plugins,
			{ type = "padding", val = 1 },
			section.greeting,
			{ type = "padding", val = 1 },
			section.footer,
		},
	}
	-- prevent autocmd sideeffects on initial load
	dashboard.opts.opts.noautocmd = true
	return {
		opts = opts,
		section = section,
	}
end

local alpha = require("alpha")
local dashboard = create_dashboard()
local dashboard_utils = require("utils.dashboard")
alpha.setup(dashboard.opts)

-- NOTE: only relevant if using lazy.nvim
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy", -- After lazy finished loading
	callback = function()
		vim.schedule(function()
			dashboard.section.plugins.val = dashboard_utils.add_border_block(dashboard_utils.get_plugin_stats())
			alpha.redraw()
		end)
	end,
})
-- TODO: allow opening dashboard with a command

return {}
