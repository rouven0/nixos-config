{ lib, config, ... }:
let
  v = (builtins.attrNames config.services.nginx.virtualHosts);
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    # virtualHosts = lib.genAttrs v (name: { extraConfig = " lohustuff goes ith ${name}"; });
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rouven@rfive.de";
    };
  };
}
