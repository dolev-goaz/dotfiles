---@diagnostic disable: unused-local
require("luasnip.session.snippet_collection").clear_snippets("markdown")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("tex", {
	-- NOTE: for now only works with english
	s("scaffold_full", {
		t({
			"\\documentclass[12pt,a4paper]{article}",
			"",
			"% === Encoding & Language ===",
			"\\usepackage[utf8]{inputenc}   % UTF-8 support",
			"\\usepackage[T1]{fontenc}      % Better font encoding",
			"\\usepackage[english]{babel}   % Language-specific rules",
			"",
			"% === Math ===",
			"\\usepackage{amsmath, amssymb, amsthm} % Math symbols & theorems",
			"",
			"% === Graphics & Figures ===",
			"\\usepackage{graphicx}         % Include images",
			"\\usepackage{float}            % Improved figure/table placement",
			"",
			"% === Tables ===",
			"\\usepackage{booktabs}         % Nicer tables",
			"\\usepackage{array}            % More column types",
			"",
			"% === Colors & Links ===",
			"\\usepackage{xcolor}           % Colored text",
			"\\usepackage{hyperref}         % Clickable links in PDF",
			"\\hypersetup{",
			"    colorlinks = true,",
			"    linkcolor = blue,",
			"    citecolor = teal,",
			"    urlcolor  = magenta",
			"}",
			"",
			"% === Lists ===",
			"\\usepackage{enumitem}         % Customizable lists",
			"",
			"% === Math Shortcuts ===",
			"\\newcommand{\\R}{\\mathbb{R}}   % Example: shortcut for real numbers",
			"\\newcommand{\\N}{\\mathbb{N}}",
			"",
			"% === Theorem Environments ===",
			"\\newtheorem{theorem}{Theorem}[section]",
			"\\newtheorem{definition}{Definition}[section]",
			"",
			"% === Margins ===",
			"\\usepackage[margin=1in]{geometry} % Page layout",
			"",
		}),

		t({ "", "% ============ actual content ============", "" }),

		t({ "", "\\begin{document}" }),
		-- \title{input here}
		t({ "", "\\title{" }),
		i(1, "Title of the Document"),
		t("}"),
		-- author
		t({ "", "\\author{" }),
		i(2, "Author Name"),
		t("}"),
		-- date
		t({ "", "\\date{\\today}" }),
		t({ "", "\\maketitle" }),

		t({ "", "", "" }), -- two newlines for spacing
		i(3, "Actual content goes here..."),
		t({ "", "", "" }), -- two newlines for spacing
		t({ "\\end{document}" }),
	}),
})
