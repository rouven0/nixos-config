{ config, pkgs, ... }:

{
  imports =
    [
      ./vifm
      ./alacritty
      ./zsh
      ./tmux
      ./git
      ./neovim
      ./packages.nix
    ];


  # programs.kdeconnect.enable = true; # doesn't work yet
}
