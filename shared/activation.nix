{ pkgs, config, ... }:
{
  system.activationScripts.report-nixos-changes = ''
    if [ -e /run/current-system ] && [ -e $systemConfig ]; then
      echo System package diff:
      ${config.nix.package}/bin/nix store diff-closures /run/current-system $systemConfig || true
    fi
    NO_FORMAT="\033[0m"
    F_BOLD="\033[1m"
    C_RED="\033[38;5;9m"
    ${pkgs.diffutils}/bin/cmp --silent \
      <(readlink /run/current-system/{initrd,kernel,kernel-modules}) \
      <(readlink $systemConfig/{initrd,kernel,kernel-modules}) \
      || echo -e "''${F_BOLD}''${C_RED}Kernel version changed, reboot is advised.''${NO_FORMAT}"
  '';
}
