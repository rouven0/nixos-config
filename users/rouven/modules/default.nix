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
      ./kdeconnect #TODO fix
      ./neovim
      ./ssh
      ./tmux
      ./vifm
      ./zsh
      ./packages.nix
    ];
}
