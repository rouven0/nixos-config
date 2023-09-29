{ ... }:
{
  networking = {
    hostName = "nuc";
    domain = "rfive.de";
    useNetworkd = true;
    enableIPv6 = true;
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    # make room for the adguard dns
    extraConfig = ''
      [Resolve]
      DNS=127.0.0.1
      DNSStubListener=no
    '';
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
