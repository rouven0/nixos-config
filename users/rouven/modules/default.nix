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
      ./theme
      ./zsh
      ./packages.nix
    ];
}
