{ config, ... }:
{
  imports = [ ./uni.nix ];

  sops.secrets = {
    "wireless-env" = { };
    "wireguard/dorm/private" = { };
    "wireguard/dorm/preshared" = { };
  };
  networking = {
    hostName = "thinkpad";
    firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # open ports for kde connect
    firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
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
          extraConfig = "disabled=1";
        };
      };
    };
    wg-quick.interfaces = {
      Dorm = {
        address = [ "10.10.10.3/32" ];
        privateKeyFile = config.sops.secrets."wireguard/dorm/private".path;
        listenPort = 51820;
        dns = [ "192.168.10.1" ];
        autostart = false;
        peers = [
          {
            publicKey = "vUmworuJFHjB4KUdkucQ+nzqO2ysARLomq4UuK1n430=";
            presharedKeyFile = config.sops.secrets."wireguard/dorm/preshared".path;
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "dorm.vpn.rfive.de:51820";
          }
        ];
      };
    };
  };
}
