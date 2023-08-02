{ config, pkgs, ... }:
{
  sops.secrets."borg/passphrase" = { };
  environment.systemPackages = [ pkgs.borgbackup ];
  services.borgmatic = {
    enable = true;
    settings = {
      location = {
        source_directories = [
          "/var/lib"
          "/var/log"
          "/nix/persist"
          "/home"
          "/etc/secureboot"
        ];

        repositories = [
          "ssh://root@192.168.10.2/mnt/backup/thinkpad"
        ];
        exclude_patterns = [
          "/home/*/.cache"
          "/home/*/.zcomp*"
          "/home/*/.zcomp*"
          "/home/*/.gradle*"
          "/home/*/.java*"
          "/home/*/.m2*"
          "/home/*/.wine*"
          "/home/*/.mypy_cache*"
          "/home/*/.local/share"
          "/home/*/.local/share"
          "/home/*/Linux/Isos"
        ];
      };
      storage = {
        encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/passphrase".path}";
        compression = "lz4";
      };
      retention = {
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 12;
        keep_yearly = 3;
      };
    };
  };
}