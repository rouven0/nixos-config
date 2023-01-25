{ config, pkgs, ... }:
let
  domain = "vault.rfive.de";
in
{
  config.sops.secrets."vaultwarden/env" = { };
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = config.sops.secrets."vaultwarden/env".path;
    config = {
      domain = domain;
      signupsAllowed = false;
      rocketPort = 8000;
    };
    services.nginx.virtualHosts."bitwarden.example.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
  };
}
