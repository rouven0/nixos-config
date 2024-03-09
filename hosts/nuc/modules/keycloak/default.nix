{ config, ... }:
let
  domain = "auth.${config.networking.domain}";
in
{
  age.secrets.keycloak = {
    file = ../../../../secrets/nuc/keycloak/db.age;
  };
  services.keycloak = {
    enable = true;
    settings = {
      http-port = 8084;
      https-port = 19000;
      hostname = domain;
      # proxy-headers = "forwarded";
      proxy = "edge";
    };
    database = {
      # host = "/var/run/postgresql/.s.PGSQL.5432";
      # useSSL = false;
      # createLocally = false;
      passwordFile = config.age.secrets.keycloak.path;
    };
    initialAdminPassword = "plschangeme";
  };
  # services.postgresql = {
  #   enable = true;
  #   ensureUsers = [
  #     {
  #       name = "keycloak";
  #       ensureDBOwnership = true;
  #     }
  #   ];
  #   ensureDatabases = [ "keycloak" ];
  # };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.keycloak.settings.http-port}";
    };
  };
}
