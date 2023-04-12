{ config, ... }:
{
  networking = {
    hostName = "nuc";
    useNetworkd = true;
  };
  systemd.network = {
    enable = true;
    enableIPv6 = true;
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
