{ config, pkgs, ... }:
{
  imports =
    [
      ./alacritty
      ./awesome
      ./flameshot
      ./git
      ./kdeconnect
      ./neovim
      ./picom
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
