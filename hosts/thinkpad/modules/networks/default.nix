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
    netdevs."20-bond0" = {
      netdevConfig = {
        Name = "bond0";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "active-backup";
        PrimaryReselectPolicy = "always";
      };
    };
    networks = {
      "20-ethernet-bond0" = {
        matchConfig.Name = "enp0s31f6";
        networkConfig = {
          Bond = "bond0";
          PrimarySlave = true;
        };
      };
      "20-wireless-bond0" = {
        matchConfig.Name = "wlp9s0";
        networkConfig = {
          Bond = "bond0";
          #IgnoreCarrierLoss = "3s";
          DHCP = "yes";
        };
      };
      "20-bond0" = {
        matchConfig.Name = "bond0";
        networkConfig = {
          #DHCP = "yes";
        };
      };
    };

    # some wireguard interfaces
    #netdevs."30-dorm" = {
    #netdevConfig = {
    #Kind = "wireguard";
    #Name = "dorm";
    #Description = "WireGuard to my Dorm Infra";
    #};
    #wireguardConfig = {
    #PrivateKeyFile = config.sops.secrets."wireguard/dorm/private".path;
    #ListenPort = 51820;
    #};
    #wireguardPeers = [
    #{
    #wireguardPeerConfig = {
    #PublicKey = "vUmworuJFHjB4KUdkucQ+nzqO2ysARLomq4UuK1n430=";
    #PresharedKeyFile = config.sops.secrets."wireguard/dorm/preshared".path;
    #AllowedIPs = [ "10.10.10.0/24" ];
    ##Endpoint = "dorm.vpn.rfive.de:51820";
    #Endpoint = "141.30.227.6:51820";
    #};
    #}
    #];
    #};
    #networks."30-dorm" = {
    #matchConfig.Name = "dorm";
    #networkConfig = {
    #Address = "10.10.10.3/32";
    #};
    #routes = [
    #{ routeConfig = { Gateway = "10.10.10.1"; Destination = "10.10.10.0/24"; }; }
    #];
    #};
  };
}
