{ ... }:
{
  programs.nix-index-database.comma.enable = true;
  imports = [
    ./activation.nix
    ./caches.nix
    ./gpg.nix
    ./sops.nix
    ./vim.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
