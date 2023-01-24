{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@rfive.de";
    };
  };
}
