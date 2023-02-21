{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # a few language servers
    python310Packages.python-lsp-server
    python310Packages.python-lsp-black
    python310Packages.black
    python310Packages.pylint
    rnix-lsp
  ];
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      nerdcommenter
      vim-repeat
      vim-airline
      fzf-vim
      dracula-vim
      vim-nix # this destroys my tab settings, ffs
      nvim-lspconfig
      nvim-cmp
      lsp-format-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
    ];
  };
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
