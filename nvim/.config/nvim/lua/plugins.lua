vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/m4xshen/hardtime.nvim" },
})

require("oil").setup({
	default_file_explorer = true,
	columns = {},
	keymaps = {
		["<C-h>"] = false,
		["<C-c>"] = false,
		["<M-h>"] = "actions.select_split",
		q = "actions.close",
	},
	delete_to_trash = true,
	view_options = {
		show_hidden = true,
	},
	skip_confirm_for_simple_edits = true,
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open Oil in a float" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

require("mini.completion").setup()

local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
	snippets = { MiniSnippets.gen_loader.from_lang() },
})
MiniSnippets.start_lsp_server({ match = false })

local MiniFiles = require("mini.files")
MiniFiles.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "L",
		go_out = "-",
		go_out_plus = "H",
	},
})
vim.keymap.set("n", "<leader>ee", function()
	MiniFiles.open()
end, { desc = "Open mini.files" })
vim.keymap.set("n", "<leader>ef", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Open current file in mini.files" })

require("mini.surround").setup({
	highlight_duration = 300,
	mappings = {
		add = "sa",
		delete = "ds",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",
		suffix_last = "l",
		suffix_next = "n",
	},
	n_lines = 20,
	respect_selection_type = false,
	search_method = "cover",
})

local MiniPick = require("mini.pick")
MiniPick.setup()
local MiniExtra = require("mini.extra")

vim.keymap.set("n", "<leader>pf", MiniPick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>pc", function()
	MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end, { desc = "Find config files" })
vim.keymap.set("n", "<leader>ps", MiniPick.builtin.grep_live, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>pws", function()
	MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>pk", MiniExtra.pickers.keymaps, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>pr", MiniExtra.pickers.oldfiles, { desc = "Find recent files" })
vim.keymap.set("n", "<leader>th", MiniExtra.pickers.colorschemes, { desc = "Pick colorscheme" })
vim.keymap.set("n", "<leader>ths", MiniExtra.pickers.colorschemes, { desc = "Pick colorscheme" })
vim.keymap.set("n", "<leader>vh", MiniPick.builtin.help, { desc = "Search help" })

require("mini.clue").setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },
	},
})

require("mini.notify").setup()
require("mini.statusline").setup()
require("hardtime").setup({})
