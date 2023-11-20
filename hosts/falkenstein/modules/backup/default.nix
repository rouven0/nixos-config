{ config, pkgs, ... }:
{
  age.secrets."borg/passphrase" = {
    file = ../../../../secrets/falkenstein/borg/passphrase.age;
  };
  environment.systemPackages = [ pkgs.borgbackup ];
  services.borgmatic = {
    enable = true;
    settings = {
      source_directories = [
        "/var/lib"
        "/var/log"
        "/root"
      ];

      repositories = [
        {
          path = "ssh://root@192.168.42.2/mnt/backup/falkenstein";
          label = "nuc";
        }
      ];
      encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."borg/passphrase".path}";
      compression = "lz4";
      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;
      keep_yearly = 3;
    };
  };
}
