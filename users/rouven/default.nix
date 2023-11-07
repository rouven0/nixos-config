{ config, ... }:
{
  imports = [ ./fixes.nix ];
  nixpkgs.config.allowUnfree = true;
  users.users.rouven = {
    description = "Rouven Seifert";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" "tss" "input" "_lldpd" "wireshark" ];
    initialHashedPassword = "$6$X3XERQv28Nt1UUT5$MjdMBDuXyEwexkuKqmNFweez69q4enY5cjMXSbBxOc6Bq7Fhhp7OqmCm02k3OGjoZFXzPV9ZHuMSGKZOtwYIk1";
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.rouven = { ... }: {
    imports = [ ./modules ./options ];

    config = {
      home.username = "rouven";
      home.homeDirectory = "/home/rouven";
      home.stateVersion = config.system.stateVersion;
    };
  };
}
