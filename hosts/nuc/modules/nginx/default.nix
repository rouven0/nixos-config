{ pkgs, lib, config, ... }:
{
  # set default options for virtualHosts
  options = with lib; {
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (types.submodule
        ({ name, ... }: {
          # split up nginx access logs per vhost
          enableACME = true;
          forceSSL = true;
          # enable http3 for all hosts
          quic = true;
          http3 = true;
          extraConfig = ''
            access_log /var/log/nginx/${name}_access.log;
            error_log /var/log/nginx/${name}_error.log;
            add_header Alt-Svc 'h3=":443"; ma=86400';
          '';
        })
      );
    };
  };
  config = {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 443 ];
    services.nginx = {
      enable = true;
      package = pkgs.nginxQuic;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
    };
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "rouven@${config.networking.domain}";
      };
    };
  };
}
