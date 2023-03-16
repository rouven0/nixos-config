{ config, pkgs, ... }:
{
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
        "<leader>d" = ":Telescope diacnostics<CR>";

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
      fugitive = {
        enable = true;
      };
      lsp = {
        enable = true;
        onAttach = ''
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<leader>b', function() vim.lsp.buf.format { async = true } end, bufopts)

        '';
        servers = {
          # pylsp is broken
          pyright = {
            enable = true;
          };
          texlab = {
            enable = true;
          };
          rnix-lsp = {
            enable = true;
          };
        };
      };
      null-ls = {
        enable = true;
        sources.formatting.black = {
          enable = true;
          withArgs = ''
            ({
              extra_args = { "-l", "120" }
            })
          '';
        };
      };
      nvim-cmp = {
        enable = true;
        mappingPresets = [ "insert" ];
        sources = [
          {
            name = "nvim_lsp";
          }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
      treesitter = {
        enable = true;
        indent = true;
        #folding = true; # somewhat broken at the moment
        grammarPackages = with pkgs.tree-sitter-grammars; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-css
          tree-sitter-go
          tree-sitter-haskell
          tree-sitter-html
          tree-sitter-java
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-lua
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-perl
          #tree-sitter-python # broken atm
          tree-sitter-regex
          tree-sitter-rst
          tree-sitter-rust
          tree-sitter-sql
          tree-sitter-toml
          tree-sitter-typescript
          tree-sitter-yaml
        ];
      };
    };
    extraPlugins = with pkgs.vimPlugins;
      [
        vim-nix
        dracula-vim
        nerdcommenter
      ];
    highlight.ColorColumn.ctermbg = "darkgray";
  };
}
