{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./alacritty
      ./fzf
      ./git
      ./gpg
      ./hyprland
      ./neovim
      ./qutebrowser
      ./ssh
      ./tmux
      ./vifm
      ./theme
      ./zsh
      ./packages.nix
    ];
}
