{ config, lib, pkgs, ... }:
{
  # set default options for virtualHosts
  options = with lib; {
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (types.submodule
        ({ name, ... }: {
          # split up nginx access logs per vhost
          extraConfig = ''
            access_log /var/log/nginx/${name}_access.log;
            error_log /var/log/nginx/${name}_error.log;
          '';
        })
      );
    };
  };
  config =
    let
      # matrix homeserver discovery
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
      user = "rfive-web";
      group = "rfive-web";
    in
    {
      users.users.${user} = {
        group = group;
        isSystemUser = true;
      };
      users.groups.${group} = { };
      services.phpfpm.pools.rfivede = {
        user = user;
        group = group;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.max_requests" = 500;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 5;
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "catch_workers_output" = true;
        };
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
      };
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      networking.firewall.allowedUDPPorts = [ 443 ];
      services.nginx = {
        enable = true;
        package = pkgs.nginxQuic;
        recommendedTlsSettings = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        virtualHosts."${config.networking.domain}" = {
          quic = true;
          http3 = true;
          enableACME = true;
          forceSSL = true;
          root = "/srv/web/${config.networking.domain}";
          extraConfig = ''
            index index.html index.php;
          '';
          locations = {
            "/" = {
              tryFiles = "$uri $uri/ /index.php?$query_string";
            };
            "~ \.php$" = {
              extraConfig = ''
                try_files $uri =404;
                fastcgi_pass unix:${config.services.phpfpm.pools.rfivede.socket};
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_index index.php;
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
              '';
            };
            "/.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
            "/.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
          };
        };
      };
      security.acme = {
        acceptTerms = true;
        defaults = {
          email = "rouven@${config.networking.domain}";
        };
      };
    };
}
