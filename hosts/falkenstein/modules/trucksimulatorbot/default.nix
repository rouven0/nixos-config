{ config, pkgs, trucksimulatorbot, ... }:
let
  domain = "trucksimulatorbot.${config.networking.domain}";
in
{
  services.trucksimulatorbot = {
    enable = true;
    discord = {
      clientId = "831052837353816066";
      publicKey = "faa7004a2a5096702f96f3ebeb45c7e8272c119b72c1a0894abc4d76d8cc8bad";
    };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "trucksimulator";
        ensurePermissions = {
          "trucksimulator.*" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "trucksimulator" ];
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
        proxyPass = "http://127.0.0.1:${toString config.services.trucksimulatorbot.listenPort}";
      };
      locations."/docs" = {
        root = "${trucksimulatorbot.packages.x86_64-linux.docs}";
      };
    };
  };
}