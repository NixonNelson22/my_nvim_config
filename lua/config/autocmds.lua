vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		print("lint works")
		require("lint").try_lint()
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		print("format works")
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Add filetype detection for Django HTML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.html", "*.htm" },
	callback = function()
		local content = vim.api.nvim_buf_get_lines(0, 0, 10, false)
		local content_str = table.concat(content, "\n")
		
		-- Check for Django template syntax
		if content_str:match("{%") or content_str:match("{{") or content_str:match("{#") then
			vim.bo.filetype = "htmldjango"
		elseif content_str:match("hx%-") or content_str:match("data%-hx") then
			-- HTMX attributes detected, keep as HTML for prettier formatting
			vim.bo.filetype = "html"
		end
	end,
})
