local M = {}

local hi_pattern = "%%#%s#%s%%*"

local modes = {
	n = { name = "NORMAL", group = "Title" },
	i = { name = "INSERT", group = "String" },
	ic = { name = "INSERT", group = "String" },
	v = { name = "VISUAL", group = "Label" },
	V = { name = "V-LINE", group = "Label" },
	["\22"] = { name = "V-BLOCK", group = "Label" },
	c = { name = "COMMAND", group = "Function" },
	R = { name = "REPLACE", group = "WarningMsg" },
	t = { name = "TERMINAL", group = "Removed" },
	nt = { name = "NORMAL", group = "Removed" },
}

local function mode()
	local current = vim.api.nvim_get_mode().mode
	local details = modes[current] or { name = current, group = "StatusLine" }
	return hi_pattern:format("StatuslineMode" .. details.group, " " .. details.name .. " ")
end

local function diagnostics()
	if vim.tbl_contains({ "c", "t" }, vim.api.nvim_get_mode().mode) then
		return " λ "
	end

	local severity = vim.diagnostic.severity
	local errors = #vim.diagnostic.get(0, { severity = severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = severity.WARN })
	local result = ""

	if errors > 0 then
		result = result .. hi_pattern:format("DiagnosticError", " ✘ " .. errors)
	end
	if warnings > 0 then
		result = result .. hi_pattern:format("DiagnosticWarn", " ▲ " .. warnings)
	end

	return result ~= "" and result or " λ "
end

local function filename()
	local name = vim.fn.expand("%:t")
	return name == "" and "[No Name]" or name:gsub("%%", "%%%%")
end

local function refresh_highlights()
	vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

	for _, group in ipairs({ "Title", "String", "Label", "Function", "WarningMsg", "Removed" }) do
		local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
		vim.api.nvim_set_hl(0, "StatuslineMode" .. group, {
			fg = highlight.fg,
			bold = true,
		})
	end
end

function M.setup()
	_G.statusline_component = {
		mode = mode,
		diagnostics = diagnostics,
		filename = filename,
	}

	vim.o.statusline = table.concat({
		"%{%v:lua.statusline_component.mode()%}",
		"%{%v:lua.statusline_component.diagnostics()%}",
		" %{%v:lua.statusline_component.filename()%} ",
		"%r%m",
		"%=",
		"%y ",
		"%3l:%-2c ",
	})
	vim.o.laststatus = 2

	refresh_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("statusline-highlights", { clear = true }),
		callback = refresh_highlights,
	})
end

return M
