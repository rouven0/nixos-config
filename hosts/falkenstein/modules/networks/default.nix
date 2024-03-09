{ config, ... }:
{
  age.secrets = {
    "wireguard/dorm/private" = {
      file = ../../../../secrets/falkenstein/wireguard/dorm/private.age;
      owner = config.users.users.systemd-network.name;
    };
    "wireguard/dorm/preshared" = {
      file = ../../../../secrets/falkenstein/wireguard/dorm/preshared.age;
      owner = config.users.users.systemd-network.name;
    };

  };
  networking = {
    hostName = "falkenstein";
    nftables.enable = true;
    domain = "rfive.de";
    useNetworkd = true;
    enableIPv6 = true;
    firewall = {
      extraInputRules = ''
        ip saddr 192.168.0.0/16 tcp dport 19531 accept comment "Allow journald gateway access from local networks"
      '';
    };
  };
  services.resolved = {
    dnssec = "true";
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
    config = {
      networkConfig = {
        SpeedMeter = true;
      };
    };
    networks."10-loopback" = {
      matchConfig.Name = "lo";
    };
    networks."10-wired" = {
      matchConfig.Name = "ens3";
      dns = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
      ];
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
        PrivateKeyFile = config.age.secrets."wireguard/dorm/private".path;
        ListenPort = 51820;
        RouteTable = "main";
        RouteMetric = 30;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "Z5lwwHTCDr6OF4lfaCdSHNveunOn4RzuOQeyB+El9mQ=";
            PresharedKeyFile = config.age.secrets."wireguard/dorm/preshared".path;
            Endpoint = "nuc.rfive.de:51820";
            AllowedIPs = "192.168.42.0/24, 192.168.43.0/24";
          };
        }
      ];
    };
    networks."30-dorm" = {
      matchConfig.Name = "wg0";
      networkConfig = {
        Address = "192.168.43.4/32";
        DNS = "192.168.42.1";
        DNSSEC = true;
        BindCarrier = [ "ens3" ];
      };
    };
  };
}
