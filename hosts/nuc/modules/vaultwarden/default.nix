{ config, ... }:
let
  domain = "vault.${config.networking.domain}";
in
{
  age.secrets.vaultwarden = {
    file = ../../../../secrets/nuc/vaultwarden.age;
    owner = "vaultwarden";
  };
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      domain = "https://${domain}";
      signupsAllowed = false;
      # somehow this works
      databaseUrl = "postgresql://vaultwarden@%2Frun%2Fpostgresql/vaultwarden";
      rocketPort = 8000;
    };
  };
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "vaultwarden" ];
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}";
    };
  };
}
