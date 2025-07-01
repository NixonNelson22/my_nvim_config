return {
	--Debug
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
		},
		config = function() end,
		opts = {
			adapters = {
				python = {
					type = "executable",
					command = os.getenv("HOME") .. "/.virtualenvs/tools/bin/python",
					args = { "-m", "debugpy.adapter" },
				},
				nlua = function(callback, config)
					callback({
						type = "server",
						host = config.host or "127.0.0.1",
						port = config.port or 8086,
					})
				end,
			},
			configurations = {
				lua = {
					{
						type = "nlua",
						request = "attach",
						name = "Attach to running Neovim instance",
					},
				},
			},
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				mode = "n",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				mode = "n",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				mode = "n",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				mode = "n",
			},
			{
				"<leader>dl",
				function()
					require("osv").launch({ port = 8086 })
				end,
				mode = "n",
			},
			{
				"<leader>dw",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.hover()
				end,
			},
			{
				"<leader>df",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.frames)
				end,
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"ChristianChiarulli/neovim-codicons",
		},
		event = "BufEnter",
		keys = {
			{
				"<leader>d",
				function()
					require("dapui").toggle()
				end,
				mode = "",
			},
		},
		config = function()
			require("dapui").setup()
			local dap = require("dap")
		end,
	},
	--Lint
	{
		"mfussenegger/nvim-lint",
		event = "BufEnter",
		config = function() end,
		opts = {
			linters_by_ft = {
				python = { "pyflakes", "pycodestyle" },
				lua = { "luacheck" },
				htmldjango = { "djlint", "curlylint" },
				css = { "biomejs" },
				javascript = { "standardjs" },
				json = { "jsonlint" },
				html = { "htmlhint" },
				yaml = { "yamllint" },
				ansible = { "ansible-lint" },
				groovy = { "npm-groovy-lint" },
				["*"] = { "codespell", "vale" },
			},
		},
	},
	--Format
	{
		"stevearc/conform.nvim",
		event = "BufWritePost",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "autopep8", "autoflake" },
				htmldjango = { "djlint" },
				html = { "prettier", "htmlbeautifier" },
				javascript = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				markdown = { "mdformat" },
				yaml = { "yamlfmt" },
				groovy = { "npm-groovy-lint" },
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
			formatters = {
				djlint = {
					command = "djlint",
					args = { "--reformat", "$FILENAME" },
					tmpfile_format = ".djlint.$RANDOM.$FILENAME",
					exit_codes = { 0, 1 },
					stdin = false,
				},
				prettier = {
					command = "prettier",
					args = { "--print-width", "100", "--tab-width", "2", "--use-tabs", "false", "$FILENAME" },
					stdin = false,
				},
			},
			default_format_opts = { lsp_format = "fallback" },
			format_on_save = { timeout_ms = 500 },
		},
	},
}
