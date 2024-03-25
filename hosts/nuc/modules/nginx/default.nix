{ lib, config, ... }:
{
  # set default options for virtualHosts
  options = with lib; {
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (types.submodule
        ({ name, ... }: {
          # split up nginx access logs per vhost
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            access_log /var/log/nginx/${name}_access.log;
            error_log /var/log/nginx/${name}_error.log;
          '';
        })
      );
    };
  };
  config = {
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
        email = "rouven@${config.networking.domain}";
      };
    };
  };
}
