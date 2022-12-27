{ config, pkgs, ... }:
{
  imports =
    [
      ./alacritty
      ./awesome
      ./git
      ./kdeconnect
      ./neovim
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
