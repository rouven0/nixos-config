{ config, ... }:
let
  domain = "cache.rfive.de";
in
{
  age.secrets.cache = {
    file = ../../../../secrets/nuc/cache.age;
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets.cache.path;
  };
  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
    };
  };
}
