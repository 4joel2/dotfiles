{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Language servers, formatters and tools are installed reproducibly by Nix.
    # Mason and plugin-managed downloads are intentionally not used.
    extraPackages = with pkgs; [
      nixd
      nixfmt

      lua-language-server
      stylua

      basedpyright
      ruff

      gopls

      bash-language-server
      shellcheck
      shfmt

      clang-tools

      fd
      ripgrep
      lazygit
    ];

    opts = {
      number = true;
      relativenumber = true;
      cursorline = true;
      guicursor = "";
      signcolumn = "yes";
      colorcolumn = "80";

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      autoindent = true;
      smartindent = true;

      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      splitright = true;
      splitbelow = true;

      ignorecase = true;
      smartcase = true;
      incsearch = true;
      inccommand = "split";

      swapfile = false;
      backup = false;
      undofile = true;
      updatetime = 200;

      mouse = "a";
      clipboard = "unnamedplus";
      completeopt = [
        "menuone"
        "noselect"
        "popup"
      ];

      # A small native statusline instead of lualine.
      laststatus = 3;
      statusline = " %f %m %= %y  %l:%c  %p%% ";
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      editorconfig = true;
    };

    colorschemes.everforest = {
      enable = true;
      settings = {
        background = "hard";
        transparent_background = 1;
        enable_italic = 1;
      };
    };

    plugins = {
      # nvim-lspconfig only supplies server definitions. Enabling and
      # configuring servers below uses Neovim's native 0.12 LSP API.
      lspconfig.enable = true;

      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          c
          cpp
          go
          gomod
          gosum
          gowork
          lua
          nix
          python
          regex
          toml
          vim
          vimdoc
          json
          markdown
          markdown_inline
          yaml
        ];
      };

      snacks = {
        enable = true;
        settings = {
          picker.enabled = true;
          explorer.enabled = true;
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
            untracked.text = "┆";
          };
        };
      };

      mini-surround = {
        enable = true;
        settings = {
          n_lines = 20;
          mappings = {
            add = "sa";
            delete = "ds";
            find = "sf";
            find_left = "sF";
            highlight = "sh";
            replace = "sr";
            update_n_lines = "sn";
          };
        };
      };
    };

    extraConfigLua = ''
      local map = vim.keymap.set
      local silent = { silent = true }

      -- General keymaps retained from the old configuration.
      map("i", "<C-c>", "<Esc>")
      map("n", "<C-c>", "<cmd>nohlsearch<CR>", silent)
      map("n", "Q", "<nop>")
      map("n", "x", '"_x')
      map({ "n", "v" }, "<leader>d", '"_d')
      map("x", "<leader>p", '"_dP')

      map("v", "J", ":m '>+1<CR>gv=gv", silent)
      map("v", "K", ":m '<-2<CR>gv=gv", silent)
      map("n", "<C-d>", "<C-d>zz")
      map("n", "<C-u>", "<C-u>zz")
      map("n", "n", "nzzzv")
      map("n", "N", "Nzzzv")

      map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
      map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
      map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
      map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

      map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        { desc = "Replace word" })

      map("n", "<leader>fp", function()
        local path = vim.fn.expand("%:~")
        vim.fn.setreg("+", path)
        vim.notify("Copied: " .. path)
      end, { desc = "Copy file path" })

      map("n", "<leader>cw", function()
        local view = vim.fn.winsaveview()
        vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
      end, { desc = "Trim trailing whitespace" })

      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight yanked text",
        group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
        callback = function() vim.hl.on_yank() end,
      })

      -- Filetype-specific native settings.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("filetype-settings", { clear = true }),
        pattern = { "python", "nix", "lua", "go", "c", "cpp", "sh", "bash" },
        callback = function() vim.bo.expandtab = true end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = "filetype-settings",
        pattern = { "sh", "bash" },
        callback = function() vim.bo.formatprg = "shfmt -i 4" end,
      })

      -- Snacks is the only general-purpose UI plugin: picker and explorer.
      map("n", "<leader>pf", function() Snacks.picker.files() end, { desc = "Find files" })
      map("n", "<leader>ps", function() Snacks.picker.grep() end, { desc = "Live grep" })
      map("n", "<leader>pb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>ph", function() Snacks.picker.help() end, { desc = "Help" })
      map("n", "<leader>e", function() Snacks.explorer() end, { desc = "File explorer" })
      map("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })

      -- Git hunks.
      map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
      map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous hunk" })
      map("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset hunk" })
      map("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>hb", require("gitsigns").blame_line, { desc = "Blame line" })

      -- Native Neovim 0.12 LSP configuration.
      vim.lsp.config("nixd", {
        settings = {
          nixd = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = { typeCheckingMode = "basic" },
          },
        },
      })

      vim.lsp.enable({
        "nixd",
        "lua_ls",
        "basedpyright",
        "ruff",
        "gopls",
        "bashls",
        "clangd",
      })

      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E ",
            [vim.diagnostic.severity.WARN] = "W ",
            [vim.diagnostic.severity.INFO] = "I ",
            [vim.diagnostic.severity.HINT] = "H ",
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("native-lsp", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method("textDocument/completion", args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
          end

          local opts = { buffer = args.buf, silent = true }
          map("n", "<leader>la", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" }))
          map("n", "<leader>lr", vim.lsp.buf.rename,
            vim.tbl_extend("force", opts, { desc = "Rename" }))
          map("n", "<leader>ld", vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
          map("n", "<leader>lq", vim.diagnostic.setloclist,
            vim.tbl_extend("force", opts, { desc = "Diagnostics list" }))
        end,
      })

      map("i", "<C-Space>", vim.lsp.completion.get, { desc = "Trigger completion" })
      map("i", "<CR>", function()
        return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
      end, { expr = true, desc = "Accept completion" })
      map("i", "<Tab>", function()
        return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
      end, { expr = true })
      map("i", "<S-Tab>", function()
        return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
      end, { expr = true })

      map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
        { desc = "Previous diagnostic" })
      map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
        { desc = "Next diagnostic" })

      map({ "n", "v" }, "<leader>f", function()
        local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/formatting" })
        if #clients > 0 then
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        elseif vim.bo.formatprg ~= "" then
          vim.cmd("normal! gggqG")
        else
          vim.notify("No formatter available", vim.log.levels.WARN)
        end
      end, { desc = "Format buffer" })
    '';
  };
}
