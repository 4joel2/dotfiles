local treesitter = require("nvim-treesitter")

treesitter.setup({})
treesitter.install({ "lua", "go", "c", "cpp", "latex", "bibtex" })

local function enable(buffer, filetype)
	local language = vim.treesitter.language.get_lang(filetype)
	if not language then
		return
	end

	local has_parser = pcall(vim.treesitter.get_parser, buffer, language)
	if has_parser and vim.treesitter.query.get(language, "highlights") then
		vim.treesitter.start(buffer, language)
	end
	if has_parser and vim.treesitter.query.get(language, "indents") then
		vim.bo[buffer].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-enable", { clear = true }),
	callback = function(event)
		enable(event.buf, event.match)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buffer) then
				enable(buffer, vim.bo[buffer].filetype)
			end
		end
	end,
})
