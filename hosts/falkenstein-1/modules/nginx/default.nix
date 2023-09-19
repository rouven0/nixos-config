{ config, ... }:
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
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@${config.networking.domain}";
    };
  };
}
