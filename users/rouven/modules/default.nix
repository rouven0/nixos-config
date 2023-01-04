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
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
