return {
	"folke/which-key.nvim",
	  dependencies = {
		  'echasnovski/mini.nvim',
	  },
	  event = "VeryLazy",
	  opts = {},
	  keys = {
		  {
			  "<leader>?",
			  function()
				  require("which-key").show({ global = false })
			  end,
			  desc = "Buffer Local Keymaps (which-key)",
		  },
	  },
  }
