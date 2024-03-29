{ config, pkgs, ... }:
{
  age.secrets."borg/passphrase" = {
    file = ../../../../secrets/thinkpad/borg/passphrase.age;
    owner = "rouven";
  };
  environment.systemPackages = [ pkgs.borgbackup ];
  services.borgmatic = {
    enable = true;
    settings = {
      source_directories = [
        "/var/lib"
        "/var/log"
        "/nix/persist"
        "/home"
        "/etc/secureboot"
      ];

      repositories = [
        {
          label = "nuc";
          path = "ssh://root@192.168.42.2/mnt/backup/thinkpad";
        }
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
        # contains very big files that don't need to clutter up the backup
        # if I ever happen to have important data in virtual machines, this can be reconsidered
        "/var/lib/libvirt"
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
