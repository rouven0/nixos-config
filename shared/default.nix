{ ... }:
{
  programs.nix-index-database.comma.enable = true;
  imports = [
    ./activation.nix
    ./gpg.nix
    ./vim.nix
    ./nix.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
  ];
}
