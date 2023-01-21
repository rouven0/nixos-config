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
      ./ssh
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
