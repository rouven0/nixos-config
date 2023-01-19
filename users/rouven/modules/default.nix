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
