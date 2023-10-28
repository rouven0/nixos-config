{ ... }:
{
  programs.nix-index-database.comma.enable = true;
  imports = [
    ./activation.nix
    ./gpg.nix
    ./sops.nix
    ./vim.nix
    ./nix.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
  ];
}
