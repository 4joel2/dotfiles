vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	virtual_text = true,
	underline = true,
	update_in_insert = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-config", { clear = true }),
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		vim.keymap.set("n", "gR", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show LSP references" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Show LSP definitions" }))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Show LSP implementations" }))
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" }))
		vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show documentation" }))
		vim.keymap.set("n", "<leader>rs", "<cmd>lsp restart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

		require("mini.clue").ensure_buf_triggers(event.buf)
	end,
})

vim.lsp.config("*", {
	capabilities = require("mini.completion").get_lsp_capabilities(),
})

vim.lsp.enable({ "lua_ls", "gopls", "clangd" })
