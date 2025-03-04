local md = require("markdown-preview")

vim.api.nvim_create_user_command("MarkdownPreview", function()
	md.start_preview()
end, {})

vim.api.nvim_create_user_command("MarkdownPreviewStop", function()
	md.stop_preview()
end, {})
