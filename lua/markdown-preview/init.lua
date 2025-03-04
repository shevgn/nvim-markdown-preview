local M = {}

-- Plugin state
M.preview_active = false
M.bs_job_id = nil

-- Функція для конвертації Markdown у HTML
local function render_markdown()
	local input_file = vim.fn.expand("%:p")
	local output_file = "preview.html"
	local pandoc_cmd = string.format("pandoc %s --quiet -s -o %s", input_file, output_file)
	os.execute(pandoc_cmd)
	return output_file
end

-- Функція оновлення HTML-файлу (викликається при збереженні, якщо режим увімкнено)
function M.update_preview()
	if not M.preview_active then
		return
	end
	local output_file = render_markdown()
	print("Preview оновлено: " .. output_file)
end

-- Функція запуску режиму preview
function M.start_preview()
	if M.preview_active then
		print("Markdown preview вже увімкнено.")
		return
	end

	M.preview_active = true

	-- Створюємо HTML при першому запуску
	local output_file = render_markdown()

	-- Запускаємо browser-sync, якщо ще не запущено
	if not M.bs_job_id then
		M.bs_job_id = vim.fn.jobstart(
			{ "browser-sync", "start", "--server", "--files", output_file },
			{ detach = true }
		)
		if M.bs_job_id <= 0 then
			print(
				"Не вдалося запустити browser-sync. Перевірте, чи він встановлений."
			)
		else
			print("Browser-sync запущено з job id: " .. M.bs_job_id)
		end
	end

	-- Створюємо групу автокоманд, щоб оновлювати preview лише коли режим активний
	vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = "MarkdownPreview",
		pattern = { "*.md" },
		callback = function()
			M.update_preview()
		end,
	})

	print("Markdown preview увімкнено.")
end

-- Функція зупинки режиму preview
function M.stop_preview()
	if not M.preview_active then
		print("Markdown preview не увімкнено.")
		return
	end

	-- Зупиняємо browser-sync
	if M.bs_job_id then
		vim.fn.jobstop(M.bs_job_id)
		print("Browser-sync зупинено.")
		M.bs_job_id = nil
	end

	-- Видаляємо автокоманди
	vim.cmd("augroup MarkdownPreview | autocmd! | augroup END")

	M.preview_active = false
	print("Markdown preview вимкнено.")
end

return M
