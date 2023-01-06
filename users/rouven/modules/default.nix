{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./alacritty
      ./flameshot
      ./fzf
      ./git
      ./kdeconnect
      ./neovim
      ./picom
      ./ssh
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
