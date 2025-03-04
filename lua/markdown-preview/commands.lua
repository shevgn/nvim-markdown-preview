local md = require("markdown-preview")

vim.api.nvim_create_user_command("PreviewMarkdown", function()
	md.start_preview()
end, {})

vim.api.nvim_create_user_command("PreviewMarkdownStop", function()
	md.stop_preview()
end, {})
