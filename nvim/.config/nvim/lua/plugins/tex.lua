return {
	"lervag/vimtex",
	init = function()
		-- sudo pacman -S zathura zathura-pdf-poppler
		-- yay -S  opensiddur-hebrew-fonts
		vim.cmd([[set conceallevel=2]])
		vim.g.vimtex_view_general_viewer = "zathura"
		vim.g.tex_conceal = "abdmg"
		vim.g.vimtex_compiler_latexmk_engines = {
			_ = "-xelatex",
		}
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = "/home/dolev/.texfiles/",
			executable = "latexmk",
			options = {
				"-xelatex",
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
	end,
}
