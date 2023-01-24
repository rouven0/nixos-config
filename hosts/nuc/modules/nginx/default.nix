{ config, ... }:
{
  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@rfive.de";
    };
  };
}
