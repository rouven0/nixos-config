{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./alacritty
      ./flameshot # TODO fix
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
