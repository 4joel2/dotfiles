return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#181210',
				base01 = '#181210',
				base02 = '#a59d99',
				base03 = '#a59d99',
				base04 = '#fff4ef',
				base05 = '#fffaf8',
				base06 = '#fffaf8',
				base07 = '#fffaf8',
				base08 = '#ffa39f',
				base09 = '#ffa39f',
				base0A = '#ffc0a1',
				base0B = '#b6ffa5',
				base0C = '#ffdecd',
				base0D = '#ffc0a1',
				base0E = '#ffcbb2',
				base0F = '#ffcbb2',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#a59d99',
				fg = '#fffaf8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffc0a1',
				fg = '#181210',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a59d99' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffdecd', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffcbb2',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffc0a1',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffc0a1',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffdecd',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#b6ffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#fff4ef' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#fff4ef' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#a59d99',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
