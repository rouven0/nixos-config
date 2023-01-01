{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./alacritty
      ./awesome
      ./flameshot
      ./fzf
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
