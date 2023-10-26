{ config, lib, ... }:
{
  sops.secrets = {
    "wireguard/dorm/private" = {
      owner = config.users.users.systemd-network.name;
    };
    "wireguard/dorm/preshared" = {
      owner = config.users.users.systemd-network.name;
    };
  };
  networking = {
    hostName = "falkenstein-1";
    nftables.enable = true;
    domain = "rfive.de";
    useNetworkd = true;
    enableIPv6 = true;
  };
  services.resolved = {
    dnssec = "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
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
        DHCP = "ipv4";
        IPv6AcceptRA = "yes";
        Address = "2a01:4f8:c012:49de::1/64";
        Gateway = "fe80::1";
      };
    };

    netdevs."30-dorm" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/dorm/private".path;
        ListenPort = 51820;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "Z5lwwHTCDr6OF4lfaCdSHNveunOn4RzuOQeyB+El9mQ=";
            PresharedKeyFile = config.sops.secrets."wireguard/dorm/preshared".path;
            Endpoint = "dorm.vpn.rfive.de:51820";
            AllowedIPs = "192.168.42.0/24, 192.168.43.0/24";
          };
        }
      ];
    };
    networks."30-dorm" = {
      matchConfig.Name = "wg0";
      networkConfig = {
        DNS = "192.168.42.1";
      };
      addresses = [
        {
          addressConfig = {
            Address = "192.168.43.4/24";
            RouteMetric = 30;
          };
        }
      ];
      routes = [
        { routeConfig = { Gateway = "0.0.0.0"; Destination = "192.168.42.0/24"; Metric = 30; }; }
      ];
    };
  };
}
