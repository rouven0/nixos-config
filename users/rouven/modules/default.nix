{ config, pkgs, ... }:
{
  imports = [
    ./accounts
    ./foot
    ./fzf
    ./git
    ./gpg
    ./hyprland
    ./neovim
    ./qutebrowser
    ./sops
    ./spotify
    ./ssh
    ./tmux
    ./vifm
    ./theme
    ./zsh
    ./packages.nix
  ];
}
