{ config, ... }:
let
  domain = "monitoring.${config.networking.domain}";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        inherit domain;
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
      database = {
        type = "postgres";
        user = "grafana";
        host = "/run/postgresql";
      };
    };
  };


  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "grafana";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "grafana" ];
  };

  services.nginx.virtualHosts."${domain}" = {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
      proxyWebsockets = true;
    };
  };
}
