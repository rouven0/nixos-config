{ ... }:
{
  programs.nix-index-database.comma.enable = true;
  imports = [
    ./activation.nix
    ./gpg.nix
    ./vim.nix
    ./nix.nix
    ./systemd.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
  ];
}
