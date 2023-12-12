{ pkgs, lib, ... }:

{
  systemd = {

    package = lib.mkDefault (pkgs.systemd.override { withHomed = false; });
    sleep.extraConfig = ''
      HibernateDelaySec=2h
    '';
    oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserServices = true;
    };
  };

}
