{ config, pkgs, ... }:
let
  domain = "matrix.${config.networking.domain}";
in
{

  sops.secrets = {
    "matrix/shared_secret" = {
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "matrix/sync/environment" = {
      # owner = "matrix-sliding-sync";
    };
  };

  services = {
    postgresql = {
      enable = true;
      ensureUsers = [{
        name = "matrix-synapse";
      }];
    };


    matrix-synapse = {
      enable = true;
      configureRedisLocally = true;
      extraConfigFiles = [ config.sops.secrets."matrix/shared_secret".path ];

      settings = {
        server_name = config.networking.domain;

        listeners = [{
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = false;
          }];
        }];
      };
      sliding-sync = {
        enable = true;
        settings = {
          SYNCV3_SERVER = "https://${domain}";
        };
        environmentFile = config.sops.secrets."matrix/sync/environment".path;
      };
    };


    nginx = {
      recommendedProxySettings = true;
      virtualHosts = {
        # synapse
        "${domain}" = {
          enableACME = true;
          forceSSL = true;


          # locations."/".extraConfig = "return 404;";

          # # proxy to synapse
          # locations."/_matrix".proxyPass = "http://[::1]:8008";
          locations."/".proxyPass = "http://[::1]:8008";
          locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)".proxyPass = "http://localhost:8009";
          # locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        };
      };
    };
  };

  systemd.services.matrix-synapse.after = [ "matrix-synapse-pgsetup.service" ];

  systemd.services.matrix-synapse-pgsetup = {
    description = "Prepare Synapse postgres database";
    wantedBy = [ "multi-user.target" ];
    after = [ "networking.target" "postgresql.service" ];
    serviceConfig.Type = "oneshot";

    path = [ pkgs.sudo config.services.postgresql.package ];

    # create database for synapse. will silently fail if it already exists
    script = ''
      sudo -u ${config.services.postgresql.superUser} psql <<SQL
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          ENCODING 'UTF8'
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      SQL
    '';
  };
}
