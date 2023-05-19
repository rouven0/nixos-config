{ config, ... }:
let
  domain = "purge.rfive.de";
in
{
  sops.secrets."purge/environment".owner = "purge";
  services.purge = {
    enable = true;
    environmentFile = config.sops.secrets."purge/environment".path;
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.purge.listenPort}";
    };
  };
}
