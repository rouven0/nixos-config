{ ... }:
{
  networking = {
    hostName = "nuc";
    domain = "rfive.de";
    useNetworkd = true;
    enableIPv6 = true;
    nftables.enable = true;
    firewall = {
      extraInputRules = ''
        ip saddr 192.168.0.0/16 tcp dport 19531 accept comment "Allow journald gateway access from local networks"
      '';
    };
  };
  services.resolved = {
    enable = true;
    # dnssec = "allow-downgrade";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    extraConfig = ''
      [Resolve]
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
        LLDP = true;
        EmitLLDP = "nearest-bridge";
      };
    };
  };
}
