return {
	"frankroeder/parrot.nvim",
	dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
	opts = {
		-- The provider definitions include endpoints, API keys, default parameters,
		-- and topic model arguments for chat summarization. You can use any name
		-- for your providers and configure them with custom functions.
		providers = {
			ollama = {
				name = "ollama",
				endpoint = "http://localhost:11434/api/chat",
				api_key = "", -- not required for local Ollama
				params = {
					chat = { temperature = 1.5, top_p = 1, num_ctx = 8192, min_p = 0.05 },
					command = { temperature = 1.5, top_p = 1, num_ctx = 8192, min_p = 0.05 },
				},
				topic_prompt = [[
	    Summarize the chat above and only provide a short headline of 2 to 3
	    words without any opening phrase like "Sure, here is the summary",
	    "Sure! Here's a shortheadline summarizing the chat" or anything similar.
	    ]],
				topic = {
					model = "mistral",
					params = { max_tokens = 32 },
				},
				headers = {
					["Content-Type"] = "application/json",
				},
				models = {
					"mistral",
				},
				resolve_api_key = function()
					return true
				end,
				process_stdout = function(response)
					if response:match("message") and response:match("content") then
						local ok, data = pcall(vim.json.decode, response)
						if ok and data.message and data.message.content then
							return data.message.content
						end
					end
				end,
				get_available_models = function(self)
					local Job = require("plenary.job")
					local url = self.endpoint:gsub("chat", "")
					local logger = require("parrot.logger")
					local job = Job:new({
						command = "curl",
						args = { "-H", "Content-Type: application/json", url .. "tags" },
					}):sync()
					local parsed_response = require("parrot.utils").parse_raw_response(job)
					self:process_onexit(parsed_response)
					if parsed_response == "" then
						logger.debug("Ollama server not running on " .. self.endpoint)
						return {}
					end

					local success, parsed_data = pcall(vim.json.decode, parsed_response)
					if not success then
						logger.error("Ollama - Error parsing JSON: " .. vim.inspect(parsed_data))
						return {}
					end

					if not parsed_data.models then
						logger.error("Ollama - No models found. Please use 'ollama pull' to download one.")
						return {}
					end

					local names = {}
					for _, model in ipairs(parsed_data.models) do
						table.insert(names, model.name)
					end

					return names
				end,
			},
		},
		-- default system prompts used for the chat sessions and the command routines
		system_prompt = {
			chat = "You are a helpful AI assistant. Provide clear, concise, and accurate responses.",
			command = "You are a helpful AI assistant. Execute commands and provide clear explanations.",
		},

		-- the prefix used for all commands
		cmd_prefix = "Prt",

		-- optional parameters for curl
		curl_params = {},

		-- The directory to store persisted state information like the
		-- current provider and the selected models
		state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

		-- The directory to store the chats (searched with PrtChatFinder)
		chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

		-- Chat user prompt prefix
		chat_user_prefix = "🗨:",

		-- llm prompt prefix
		llm_prefix = "🦜:",

		-- Explicitly confirm deletion of a chat file
		chat_confirm_delete = true,

		-- Local chat buffer shortcuts
		chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
		chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
		chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
		chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

		-- Option to move the cursor to the end of the file after finished respond
		chat_free_cursor = false,

		-- use prompt buftype for chats (:h prompt-buffer)
		chat_prompt_buf_type = false,

		-- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
		-- values: popup / split / vsplit / tabnew
		toggle_target = "vsplit",

		-- The interactive user input appearing when can be "native" for
		-- vim.ui.input or "buffer" to query the input within a native nvim buffer
		-- (see video demonstrations below)
		user_input_ui = "native",

		-- Popup window layout
		-- border: "single", "double", "rounded", "solid", "shadow", "none"
		style_popup_border = "single",

		-- margins are number of characters or lines
		style_popup_margin_bottom = 8,
		style_popup_margin_left = 1,
		style_popup_margin_right = 2,
		style_popup_margin_top = 2,
		style_popup_max_width = 160,

		-- Prompt used for interactive LLM calls like PrtRewrite where {{llm}} is
		-- a placeholder for the llm name
		command_prompt_prefix_template = "🤖 {{llm}} ~ ",

		-- auto select command response (easier chaining of commands)
		-- if false it also frees up the buffer cursor for further editing elsewhere
		command_auto_select_response = true,

		-- Time in hours until the model cache is refreshed
		-- Set to 0 to deactivate model caching
		model_cache_expiry_hours = 48,

		-- fzf_lua options for PrtModel and PrtChatFinder when plugin is installed
		fzf_lua_opts = {
			["--ansi"] = true,
			["--sort"] = "",
			["--info"] = "inline",
			["--layout"] = "reverse",
			["--preview-window"] = "nohidden:right:75%",
		},

		-- Enables the query spinner animation
		enable_spinner = true,
		-- Type of spinner animation to display while loading
		-- Available options: "dots", "line", "star", "bouncing_bar", "bouncing_ball"
		spinner_type = "star",
		-- Show hints for context added through completion with @file, @buffer or @directory
		show_context_hints = true
	}
}
