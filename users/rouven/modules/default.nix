{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./awesome
      ./alacritty
      ./flameshot
      ./fzf
      ./git
      ./gpg
      ./hyprland
      ./kdeconnect
      ./neovim
      #./picom
      ./ssh
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
