{ config, pkgs, ... }:
{
  sops.secrets."borg/passphrase" = { };
  environment.systemPackages = [ pkgs.borgbackup ];
  fileSystems."/mnt/backup" =
    {
      device = "/dev/disk/by-uuid/74e78699-fe27-4467-a9bb-99fc6e8d52c5";
      fsType = "ext4";
      options = [ "nofail" ];
      neededForBoot = false;
    };
  services.borgmatic = {
    enable = true;
    settings = {
      location.source_directories = [
        "/var/lib"
        "/var/log"
        "/nix/persist"
      ];
      location.repositories = [
        "/mnt/backup/nuc"
      ];
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
