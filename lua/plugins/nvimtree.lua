return {
	'nvim-tree/nvim-tree.lua',
	lazy = false,
	opts= {
		sort = {
			sorter = "case_sensitive",
	},
		view = {
	width = 30,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
	},
	keys = {
		{"n", '<cmd>NvimTreeToggle<CR>', mode = {"n"}}
	},
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.opt.termguicolors = true
	end,
}
