{ pkgs, config, ... }:
{
  imports = [ ./uni.nix ];

  age.secrets = {
    wireless = {
      file = ../../../../secrets/thinkpad/wireless.age;
    };
    "wireguard/dorm/private" = {
      file = ../../../../secrets/thinkpad/wireguard/dorm/private.age;
      owner = config.users.users.systemd-network.name;
    };
    "wireguard/dorm/preshared" = {
      file = ../../../../secrets/thinkpad/wireguard/dorm/preshared.age;
      owner = config.users.users.systemd-network.name;
    };

  };
  environment.systemPackages = with pkgs; [
    mtr
    whois
    inetutils
    openssl
    wget
    dnsutils
  ];
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
    nftables.enable = true;
    useNetworkd = true;
    hostName = "thinkpad";
    hostId = "d8d34032";
    enableIPv6 = true;
    firewall = {
      logRefusedConnections = false;
    };
    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = config.age.secrets.wireless.path;
      networks = {
        "@HOME_SSID@" = {
          psk = "@HOME_PSK@";
          authProtocols = [ "WPA-PSK" ];
        };
        "@DORM_SSID@" = {
          psk = "@DORM_PSK@";
          authProtocols = [ "SAE" ];
        };
        "@DORM5_SSID@" = {
          priority = 5;
          psk = "@DORM_PSK@";
          authProtocols = [ "SAE" ];
        };
        "@PIXEL_SSID@" = {
          psk = "@PIXEL_PSK@";
          authProtocols = [ "WPA-PSK" ];
        };
        "WIFI@DB" = {
          authProtocols = [ "NONE" ];
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
    networks."10-wired-default" = {
      matchConfig.Name = "en*";
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
    netdevs."30-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets."wireguard/dorm/private".path;
        ListenPort = 51820;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "Z5lwwHTCDr6OF4lfaCdSHNveunOn4RzuOQeyB+El9mQ=";
            PresharedKeyFile = config.age.secrets."wireguard/dorm/preshared".path;
            Endpoint = "141.30.227.6:51820";
            AllowedIPs = "192.168.42.0/24, 192.168.43.0/24";
          };
        }
      ];
    };
    networks."30-wg0" = {
      matchConfig.Name = "wg0";
      networkConfig = {
        DNS = "192.168.42.1";
      };
      addresses = [
        {
          addressConfig = {
            Address = "192.168.43.3/24";
            RouteMetric = 30;
          };
        }
      ];
      routes = [
        # allowedIPs is somewhat broken
        { routeConfig = { Gateway = "0.0.0.0"; Destination = "192.168.42.0/24"; Metric = 30; }; }
      ];
    };
  };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };
  users.groups.etherape = { };
  security.wrappers.etherape = {
    source = "${pkgs.etherape}/bin/etherape";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "etherape"; # too lazy to create a new one
    permissions = "u+rx,g+x";
  };
}
