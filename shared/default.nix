{ ... }:
{
  programs.nix-index-database.comma.enable = true;
  imports = [
    ./caches.nix
    ./gpg.nix
    ./sops.nix
    ./vim.nix
    ./zsh.nix
  ];
}
