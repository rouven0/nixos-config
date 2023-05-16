{ config, ... }:
{
  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "rouven" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
      lib = {
        SUBVOLUME = "/var/lib";
        ALLOW_USERS = [ "rouven" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
    };
  };
}
