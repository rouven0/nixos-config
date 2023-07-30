{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts."rfive.de" = {
      enableACME = true;
      forceSSL = true;
      root = "/srv/web/rfive.de";
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@rfive.de";
    };
  };
}
