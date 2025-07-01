require("config.lazy")
require("config.autocmds")
require("config.keymaps")
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.opt.filetype = "on"
vim.cmd("filetype plugin indent on")
vim.opt.colorcolumn = { 80 }
vim.opt.background = "dark"
vim.cmd("colorscheme retrobox")