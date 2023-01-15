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
    networks."10-wireless" = {
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
      networkConfig = {
        Address = "10.10.10.3/24";
        DNS = "10.10.10.1";
        DNSDefaultRoute = true;
      };
      linkConfig = {
        ActivationPolicy = "manual"; #manual activation cause sometimes the endpoint can't be resolved
      };
      routes = [
        # Somehow systemd-networkd always creates a route to 10.10.10.0/24 with metric 0 and regardless how I set it,
        # my settings are ignored and set to 0. Route below would do it right, as soon as I find out how I can deacivate
        # the metric 0 one, this will be uncommented
        #{ routeConfig = { Gateway = "0.0.0.0"; Destination = "10.10.10.0/24"; Metric = 50; }; }
        { routeConfig = { Gateway = "0.0.0.0"; Destination = "192.168.10.0/24"; Metric = 50; }; }
      ];
    };
  };
}
