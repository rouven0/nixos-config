
{
  fileSystems."/mnt/backup" =
    {
      device = "/dev/disk/by-uuid/f6905cdb-c130-465a-90a3-93997023b5d3 ";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
      neededForBoot = false;
    };

  fileSystems."/mnt/pool" =
    {
      device = "/dev/disk/by-uuid/16b0bd14-1b07-477d-a20d-982f9467f6df";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
    };
  
  services.btrbk = {
    instances."nuc-to-disk".settings = {
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      target_preserve = "30d 4w 12m";
      target_preserve_min = "2d";
      volume = {
        "/mnt/pool" = {
          subvolume = {
            log = {
              snapshot_create = "always";
            };
            lib = {
              snapshot_create = "always";
            };
          };
          target = "/mnt/backup/nuc";
        };
      };
    };
  };
}
