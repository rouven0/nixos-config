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
  networking = {
    useNetworkd = true;
    hostName = "thinkpad";
    hostId = "79353b92"; # Define your hostname.
    firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }]; # open ports for kde connect
    firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
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
      networkConfig = {
        DHCP = "yes";
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
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
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
            PublicKey = "vUmworuJFHjB4KUdkucQ+nzqO2ysARLomq4UuK1n430=";
            PresharedKeyFile = config.sops.secrets."wireguard/dorm/preshared".path;
            Endpoint = "dorm.vpn.rfive.de:51820";
            AllowedIPs = "10.10.10.0/24, 192.168.10.0/24"; # seems to be broken, has no effect on routes
          };
        }
      ];
    };
    networks."30-dorm" = {
      matchConfig.Name = "dorm";
      addresses = [
        {
          addressConfig = {
            Address = "10.10.10.3/24";
            RouteMetric = 30;
          };
        }
      ];
      routes = [
        { routeConfig = { Gateway = "0.0.0.0"; Destination = "192.168.10.0/24"; Metric = 30; }; }
      ];
    };
  };
}
