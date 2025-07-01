return {
	-- LSP Support
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
			local path = require("mason-core.path")
			require("mason").setup({
				install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
				---'"prepend"' | '"append"' | '"skip"'
				PATH = "prepend",
				log_level = vim.log.levels.INFO,
				max_concurrent_installers = 4,
				providers = {
					"mason.providers.registry-api",
					"mason.providers.client",
				},
				github = {
					download_url_template = "https://github.com/%s/releases/download/%s/%s",
				},
				pip = {
					upgrade_pip = false,
					install_args = {},
				},
				ui = {
					check_outdated_packages_on_open = true,
					border = "none",
					width = 0.8,
					height = 0.9,
					icons = {
						package_installed = "✔️",
						packnage_pending = "⭕",
						package_uninstalled = "❌",
					},
					keymaps = {
						toggle_package_expand = "<CR>",
						install_package = "i",
						update_package = "u",
						check_package_version = "c",
						update_all_packages = "U",
						check_outdated_packages = "C",
						uninstall_package = "X",
						cancel_installation = "<C-c>",
						apply_language_filter = "<C-f>",
						toggle_package_install_log = "<CR>",
						toggle_help = "g?",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ansiblels",
					"cssls",
					"docker_compose_language_service",
					"dockerls",
					"biome",
					"htmx",
					"html",
					"gradle_ls",
					"yamlls",
					"bashls",
					"basedpyright",
					"vale_ls",
					"emmet_ls",
					"lua_ls",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").basedpyright.setup({
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
							diagnosticMode = "openFilesOnly",
							inlayHints = {
								callArgumentNames = true,
							},
						},
					},
				},
			})
			require("lspconfig").lua_ls.setup({
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end
					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = { vim.env.VIMRUNTIME },
						},
					})
				end,
				settings = { Lua = {} },
			})
		end,
	},
	--completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
		},
		lazy = false,
		opts = function(_, opts)
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
						vim.snippet.expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "luasnip" },
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
			})
		end,
	},
}
