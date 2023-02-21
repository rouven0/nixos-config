{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    python310Packages.python-lsp-server
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
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
    ];
  };
  xdg.configFile."nvim/init.lua".source = ./nvim.lua;
}
