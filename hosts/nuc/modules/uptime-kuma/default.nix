{ ... }:
let
  domain = "monitoring.rfive.de";
in
{
  services.uptime-kuma = {
    enable = true;
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
    };
  };

}
