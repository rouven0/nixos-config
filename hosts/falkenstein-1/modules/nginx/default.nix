{ config, ... }:
# matrix homeserver discovery
let
  matrix_domain = "matrix.${config.networking.domain}";
  serverConfig = {
    "m.server" = "${matrix_domain}:443";
  };
  clientConfig = {
    "m.homeserver" = {
      base_url = "https://${matrix_domain}";
      # server_name = config.networking.domain;
    };
    "org.matrix.msc3575.proxy" = {
      url = "https://${matrix_domain}";
    };
  };
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts."${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;
      root = "/srv/web/${config.networking.domain}";
      locations."/.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      locations."/.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@${config.networking.domain}";
    };
  };
}
