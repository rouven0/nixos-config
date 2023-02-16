{ config, ... }:
{
  services.snapper = {
    snapshotRootOnBoot = true;
    configs = {
      root = {
        subvolume = "/";
        extraConfig = ''
          ALLOW_USERS="rouven"
          TIMELINE_CREATE=yes
          TIMELINE_CLEANUP=yes
        '';
      };
      home = {
        subvolume = "/home";
        extraConfig = ''
          ALLOW_USERS="rouven"
          TIMELINE_CREATE=yes
          TIMELINE_CLEANUP=yes
        '';
      };
      lib = {
        subvolume = "/var/lib";
        extraConfig = ''
          ALLOW_USERS="rouven"
          TIMELINE_CREATE=yes
          TIMELINE_CLEANUP=yes
        '';
      };
    };
  };
}
