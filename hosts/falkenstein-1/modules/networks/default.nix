{ config, ... }:
{
  networking = {
    hostName = "nuc";
    useNetworkd = true;
    enableIPv6 = true;
  };
  systemd.network = {
    enable = true;
    networks."10-loopback" = {
      matchConfig.Name = "lo";
      linkConfig.RequiredForOnline = false;
    };
    networks."10-wired" = {
      matchConfig.Name = "ens3";
      networkConfig = {
        DHCP = "yes";
      };
    };
  };
}
