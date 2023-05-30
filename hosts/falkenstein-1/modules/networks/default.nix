{ ... }:
{
  services.radvd = {
    enable = true;
    config = ''
      interface ens3 {
        AdvSendAdvert on;
        prefix 2a01:4f8:c012:49de::/64 {};
      };
    '';
  };
  networking = {
    hostName = "falkenstein-1";
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
        IPv6AcceptRA = "yes";
      };
    };
  };
}
