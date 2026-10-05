local M = {}

function M.open(command)
	local buffer = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local window = vim.api.nvim_open_win(buffer, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Terminal ",
		title_pos = "center",
	})

	local job
	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		if job and job > 0 then
			pcall(vim.fn.jobstop, job)
		end
		if vim.api.nvim_win_is_valid(window) then
			vim.api.nvim_win_close(window, true)
		end
		if vim.api.nvim_buf_is_valid(buffer) then
			vim.api.nvim_buf_delete(buffer, { force = true })
		end
	end

	job = vim.fn.jobstart(command or vim.o.shell, {
		term = true,
		on_exit = function()
			vim.schedule(close)
		end,
	})
	if job <= 0 then
		close()
		vim.notify("Could not start terminal", vim.log.levels.ERROR)
		return
	end

	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buffer })
	vim.keymap.set("n", "q", close, { buffer = buffer, desc = "Close terminal" })
	vim.cmd.startinsert()
end

function M.setup()
	vim.api.nvim_create_user_command("FloatTerm", function()
		M.open()
	end, {})
	vim.keymap.set("n", "<leader>tt", M.open, { desc = "Open floating terminal" })
	vim.keymap.set("n", "<leader>lg", function()
		M.open({ "lazygit" })
	end, { desc = "Open LazyGit" })
end

return M
