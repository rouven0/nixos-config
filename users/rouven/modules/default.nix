{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./alacritty
      ./flameshot
      ./fzf
      ./git
      ./gpg
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
