{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@rfive.de";
    };
  };
}
