{ lib, pkgs, ... }:
{
  system.activationScripts.report-nixos-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2) || true
  '';
}
