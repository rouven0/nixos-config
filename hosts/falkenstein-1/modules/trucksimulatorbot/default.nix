{ config, ... }:
let
  domain = "trucksimulatorbot.rfive.de";
in
{
  services.trucksimulatorbot = {
    images.enable = true;
  };
  services.nginx.virtualHosts."images.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.trucksimulatorbot.images.listenPort}";
    };
  };
}
