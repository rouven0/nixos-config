{ config, ... }:
let
  domain = "cache.rfive.de";
in
{
  sops.secrets."nix-serve/secretkey" = { };
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.sops.secrets."nix-serve/secretkey".path;
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
    };
  };
}
