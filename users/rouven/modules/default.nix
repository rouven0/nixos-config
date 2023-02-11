{ config, pkgs, ... }:
{
  imports =
    [
      ./accounts
      ./foot
      ./fzf
      ./git
      ./gpg
      ./hyprland
      ./neovim
      ./qutebrowser
      ./ssh
      ./tmux
      ./vifm
      ./theme
      ./zsh
      ./packages.nix
    ];
}
