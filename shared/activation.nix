{ config, ... }:
{
  system.activationScripts.report-nixos-changes = ''
    if [ -e /run/current-system ] && [ -e $systemConfig ]; then
      echo System package diff:
      ${config.nix.package}/bin/nix store diff-closures /run/current-system $systemConfig || true
    fi
  '';
}
