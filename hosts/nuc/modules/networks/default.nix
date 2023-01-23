{ config, ... }:
{
  networking = {
    hostName = "nuc"; # Define your hostname.
    hostId = "795a4952";
    useNetworkd = true;
  };
  systemd.network = {
    enable = true;
    networks."10-loopback" = {
      matchConfig.Name = "lo";
      linkConfig.RequiredForOnline = false;
    };
    networks."10-wired" = {
      matchConfig.Name = "eno1";
      networkConfig = {
        DHCP = "yes";
      };
    };
  };
}
