return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	config = function()
		require("neogen").setup({
			enabled = true,
			annotation_convention = "doxygen",
			filetype_conventions = {
				c = "doxygen",
				cpp = "doxygen",
			},
		})
		vim.keymap.set(
			"n",
			"<leader>df",
			":lua require('neogen').generate({ type = 'func' })<CR>",
			{ desc = "Generate documentation with Neogen" }
		)
		vim.keymap.set(
			"n",
			"<leader>dc",
			":lua require('neogen').generate({ type = 'class' })<CR>",
			{ desc = "Generate documentation with Neogen" }
		)
	end,
}
