{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
  ];
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    colorscheme = "dracula";
    options =
      {
        shiftwidth = 4;
        expandtab = false;
        preserveindent = true;
        number = true;
        relativenumber = true;
        tabstop = 4;
        smartcase = true;
        colorcolumn = "120";
        wrap = false;
      };
    globals = {
      mapleader = " ";
      dracula_colorterm = 0;
    };
    maps = {
      normalVisualOp = {
        ";" = ":";
        ":" = ";";
      };
      normal = {
        # remove ex mode shortcut
        "Q" = "<Nop>";
        # Open the tree
        "<leader>n" = ":NvimTreeFocus<CR>";
        #trigger the fuzzy finder (telescope)
        "<leader>f" = ":Telescope find_files<CR>";
        "<leader>g" = ":Telescope git_files<CR>";
        "<leader>r" = ":Telescope live_grep<CR>";
        # diacnostics
        "<leader>e" = "vim.diagnostic.open_float";
        "<leader>q" = "vim.diagnostic.setloclist";

        #quickfixlist binds
        "<C-j>" = ":cnext<CR>";
        "<C-k>" = ":cprev<CR>";

        #locallist binds
        "<C-l>" = ":lnext<CR>";
        "<C-h>" = ":lprev<CR>";

        #split  keybinds
        "<leader>s" = ":sp<CR>";
        "<leader>v" = ":vs<CR>";
        "<leader>h" = "<C-w>h";
        "<leader>j" = "<C-w>j";
        "<leader>k" = "<C-w>k";
        "<leader>l" = "<C-w>l";

      };
    };
    plugins = {
      airline = {
        enable = true;
        powerline = true;
      };
      nvim-tree = {
        enable = true;
        autoClose = true;
        openOnSetup = true;
        openOnSetupFile = true;
      };
      telescope = {
        enable = true;
      };
      lsp = {
        enable = true;
        onAttach = ''
          require("lsp-format").on_attach(client)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        '';
        servers = {
          pyright = {
            enable = true;
          };
          rnix-lsp = {
            enable = true;
          };
        };
      };
      nvim-cmp = {
        enable = true;
        sources = [
          {
            name = "nvim_lsp";
          }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };
    extraPlugins = with pkgs.vimPlugins;
      [
        vim-nix
        dracula-vim
        nerdcommenter
        lsp-format-nvim
      ];
    highlight.ColorColumn.ctermbg = "darkgray";
    extraConfigLuaPre = ''
      local lsp_format = require("lsp-format")
    '';
  };
}
