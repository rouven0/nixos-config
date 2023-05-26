{ config, ... }:
let
  domain = "trucksimulatorbot.rfive.de";
in
{
  services.trucksimulatorbot = {
    images.enable = true;
  };
  services.nginx.virtualHosts = {
    "images.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.trucksimulatorbot.images.listenPort}";
      };
    };
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/invite".return = " 301 https://discord.com/api/oauth2/authorize?client_id=831052837353816066&permissions=262144&scope=bot%20applications.commands";
      locations."/" = {
        proxyPass = "http://127.0.0.1:9000";
      };
    };
  };
}

