-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'CRAG666/betterTerm.nvim',
    opts = {
      position = 'bot',
      size = 15,
      lazy = false,
    },
    { 'CRAG666/code_runner.nvim', config = true },
    {
      'xiyaowong/transparent.nvim',
    },
    {
      'mfussenegger/nvim-dap',
    },
    {
      'olexsmir/gopher.nvim',
      ft = 'go',
      -- branch = "develop", -- if you want develop branch
      -- keep in mind, it might break everything
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'mfussenegger/nvim-dap', -- (optional) only if you use `gopher.dap`
      },
      -- (optional) will update plugin's deps on every update
      build = function()
        vim.cmd.GoInstallDeps()
      end,
      ---@type gopher.Config
      opts = {},
    },
    {
      'lervag/vimtex',
      lazy = false, -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = 'sioyek'
      end,
    },
    {
      'donRaphaco/neotex',
      init = function()
        vim.g.neotex_enabled = 2
      end,
    },
    {
      'evesdropper/luasnip-latex-snippets.nvim',
    },
    -- {
    -- 'ThePrimeagen/harpoon.nvim',
    -- lazy = true,
    -- },
    --
  },
}
