return {
	'romgrk/barbar.nvim',
	dependencies = {
		'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
		'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
	},
	lazy = false,
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {},
	version = '^1.0.0', -- optional: only update when a new 1.x version is released
	keys = {

		-- Move to previous/next
		{ '<A-,>', '<Cmd>BufferPrevious<CR>', mode={"n"}},
		{ '<A-.>', '<Cmd>BufferNext<CR>', mode={"n"}},
		-- Re-order to previous/next
		{ '<A-<>', '<Cmd>BufferMovePrevious<CR>', mode={"n"}},
		{ '<A->>', '<Cmd>BufferMoveNext<CR>', mode={"n"}},
		-- Goto buffer in position...
		{ '<A-1>', '<Cmd>BufferGoto 1<CR>', mode={"n"}},
		{ '<A-2>', '<Cmd>BufferGoto 2<CR>', mode={"n"}},
		{ '<A-3>', '<Cmd>BufferGoto 3<CR>', mode={"n"}},
		{ '<A-4>', '<Cmd>BufferGoto 4<CR>', mode={"n"}},
		{ '<A-5>', '<Cmd>BufferGoto 5<CR>', mode={"n"}},
		{ '<A-6>', '<Cmd>BufferGoto 6<CR>', mode={"n"}},
		{ '<A-7>', '<Cmd>BufferGoto 7<CR>', mode={"n"}},
		{ '<A-8>', '<Cmd>BufferGoto 8<CR>', mode={"n"}},
		{ '<A-9>', '<Cmd>BufferGoto 9<CR>', mode={"n"}},
		{ '<A-0>', '<Cmd>BufferLast<CR>', mode={"n"}},
		-- Pin/unpin buffer
		{ '<A-p>', '<Cmd>BufferPin<CR>', mode={"n"}},
		-- Goto pinned/unpinned buffer
		--                 :BufferGotoPinned
		--                 :BufferGotoUnpinned
		-- Close buffer
		{ '<A-c>', '<Cmd>BufferClose<CR>', mode={"n"}},
		-- Wipeout buffer
		--                 :BufferWipeout
		-- Close commands
		--                 :BufferCloseAllButCurrent
		--                 :BufferCloseAllButPinned
		--                 :BufferCloseAllButCurrentOrPinned
		--                 :BufferCloseBuffersLeft
		--                 :BufferCloseBuffersRight
		{ '<C-p>', '<Cmd>BufferPick<CR>', mode={"n"}},
		{ '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', mode={"n"}},
		{ '<Space>bn', '<Cmd>BufferOrderByName<CR>', mode={"n"}},
		{ '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', mode={"n"}},
		{ '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', mode={"n"}},
		{ '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', mode={"n"}}
	},
}
