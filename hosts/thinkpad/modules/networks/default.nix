{ config, ... }:
{
  imports = [ ./uni.nix ];

  sops.secrets."wireless-env" = {};
  networking = {
    hostName = "thinkpad";
    firewall = {
      allowedUDPPorts = [ 51820 ]; # used for wireguard
      checkReversePath = false;
    };
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
          extraConfig = ''
            disabled=1
          '';
        };
      };
    };
  };
}
