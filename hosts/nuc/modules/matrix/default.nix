{ config, pkgs, ... }:
let
  domain = "matrix.${config.networking.domain}";
  domainClient = "chat.${config.networking.domain}";
  clientConfig = {
    "m.homeserver" = {
      base_url = "https://${domain}:443";
    };
  };
in
{

  age.secrets = {
    "matrix/shared" = {
      file = ../../../../secrets/nuc/matrix/shared.age;
      owner = config.systemd.services.matrix-synapse.serviceConfig.User;
    };
    "matrix/sync" = {
      file = ../../../../secrets/nuc/matrix/sync.age;
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
      extraConfigFiles = [ config.age.secrets."matrix/shared".path ];
      log = {
        root.level = "WARNING";
      };

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
    };
    matrix-sliding-sync = {
      enable = true;
      settings = {
        SYNCV3_SERVER = "https://${domain}";
      };
      environmentFile = config.age.secrets."matrix/sync".path;
    };


    nginx = {
      recommendedProxySettings = true;
      virtualHosts = {
        # synapse
        "${domain}" = {
          # locations."/".extraConfig = "return 404;";

          # # proxy to synapse
          # locations."/_matrix".proxyPass = "http://[::1]:8008";
          locations."/".proxyPass = "http://[::1]:8008";
          locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)".proxyPass = "http://localhost:8009";
          # locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        };


        # element
        "${domainClient}" = {
          root = pkgs.element-web.override {
            conf = {
              default_server_config = {
                inherit (clientConfig) "m.homeserver";
                "m.identity_server".base_url = "";
              };
              disable_3pid_login = true;
            };
          };
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
