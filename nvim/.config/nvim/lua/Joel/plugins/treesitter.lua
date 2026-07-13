return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- In nvim 0.12+ with the new nvim-treesitter rewrite:
			-- 1. nvim-treesitter.configs is gone.
			-- 2. Highlighting, folding, and indent are handled by Neovim core or via different APIs.
			-- 3. ensure_installed is replaced by require('nvim-treesitter').install()

			local treesitter = require("nvim-treesitter")

			-- Configure installation (optional if defaults are okay)
			treesitter.setup({
				-- install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Ensure parsers are installed (replacing ensure_installed)
			treesitter.install({
				"json",
				"javascript",
				"go",
				"yaml",
				"html",
				"css",
				"python",
				"http",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"c",
				"cpp",
				"java",
				"rust",
			})

			-- Enable treesitter features via autocommand (New way for nvim 0.12+)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ft = vim.bo.filetype
					if ft == "" or ft == "snacks_dashboard" or ft == "alpha" or ft == "dashboard" then
						return
					end

					local lang = vim.treesitter.language.get_lang(ft) or ft
					-- In 0.12.2, get_parser returns nil for missing parsers, but start() asserts it.
					local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
					if ok and parser then
						vim.treesitter.start(0, lang)

						-- Enable indentation provided by nvim-treesitter
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

						-- Enable folding provided by Neovim core
						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
			})
		end,
	},
	-- NOTE: js,ts,jsx,tsx Auto Close Tags
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
		config = function()
			-- Independent nvim-ts-autotag setup
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto-close tags
					enable_rename = true, -- Auto-rename pairs
					enable_close_on_slash = false, -- Disable auto-close on trailing `</`
				},
				per_filetype = {
					["html"] = {
						enable_close = true, -- Disable auto-closing for HTML
					},
					["typescriptreact"] = {
						enable_close = true, -- Explicitly enable auto-closing (optional, defaults to `true`)
					},
				},
			})
		end,
	},
}
