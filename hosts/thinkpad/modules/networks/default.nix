{ config, ... }:
{
  imports = [ ./uni.nix ];

  sops.secrets = {
    "wireless-env" = { };
    "wireguard/dorm/private" = {
      owner = config.users.users.systemd-network.name;
    };
    "wireguard/dorm/preshared" = {
      owner = config.users.users.systemd-network.name;
    };
  };
  services.lldpd.enable = true;
  services.resolved = {
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    # allow downgrade since fritzbox at home doesn't support it (yet?)
    dnssec = "allow-downgrade";
  };
  networking = {
    useNetworkd = true;
    hostName = "thinkpad";
    hostId = "d8d34032";
    enableIPv6 = true;
    firewall.allowedTCPPorts = [ 24727 ];
    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = config.sops.secrets."wireless-env".path;
      networks = {
        "@HOME_SSID@" = {
          psk = "@HOME_PSK@";
          authProtocols = [ "WPA-PSK" ];
        };
        "@DORM_SSID@" = {
          psk = "@DORM_PSK@";
          authProtocols = [ "SAE" ];
        };
        "@PIXEL_SSID@" = {
          psk = "@PIXEL_PSK@";
          authProtocols = [ "WPA-PSK" ];
        };
      };
    };
  };
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks."10-loopback" = {
      matchConfig.Name = "lo";
      linkConfig.RequiredForOnline = false;
    };
    networks."10-wired" = {
      matchConfig.Name = "enp0s31f6";
      linkConfig.RequiredForOnline = false;
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 10;
      };
    };
    networks."10-wireless-home" = {
      matchConfig = {
        Name = "wlp9s0";
        SSID = "Smoerrebroed";
      };
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 20;
      };
      routes = [
        # Route to the Model train network via raspi
        { routeConfig = { Gateway = "192.168.178.63"; Destination = "192.168.179.0/24"; }; }
      ];
    };
    networks."15-wireless-default" = {
      matchConfig.Name = "wlp9s0";
      linkConfig.RequiredForOnline = false;
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
        IPv6AcceptRA = "yes";
        IPv6PrivacyExtensions = "yes";
      };
      dhcpV4Config = {
        RouteMetric = 20;
      };

    };

    # some wireguard interfaces
    netdevs."30-dorm" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "dorm";
        Description = "WireGuard to my Dorm Infra";
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
            Endpoint = "141.30.227.6:51820";
            # Endpoint = "dorm.vpn.rfive.de:51820";
            AllowedIPs = "192.168.2.0/24, 192.168.1.0/24";
          };
        }
      ];
    };
    networks."30-dorm" = {
      matchConfig.Name = "dorm";
      networkConfig = {
        DNS = "192.168.1.1";
      };
      addresses = [
        {
          addressConfig = {
            Address = "192.168.2.3/24";
            RouteMetric = 30;
          };
        }
      ];
      routes = [
        # allowedIPs is somewhat broken
        { routeConfig = { Gateway = "0.0.0.0"; Destination = "192.168.1.0/24"; Metric = 30; }; }
      ];
    };
  };
}
