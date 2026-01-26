return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#181210',
				base01 = '#181210',
				base02 = '#5c6370',
				base03 = '#5c6370',
				base04 = '#abb2bf',
				base05 = '#ffffff',
				base06 = '#ffffff',
				base07 = '#ffffff',
				base08 = '#e05f91',
				base09 = '#e05f91',
				base0A = '#ffc39b',
				base0B = '#abe086',
				base0C = '#997250',
				base0D = '#ffc39b',
				base0E = '#b46353',
				base0F = '#b46353',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#5c6370',
				fg = '#ffffff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffc39b',
				fg = '#181210',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#5c6370' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#997250', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b46353',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffc39b',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffc39b',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#997250',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#abe086',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#abb2bf' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#abb2bf' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#5c6370',
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
