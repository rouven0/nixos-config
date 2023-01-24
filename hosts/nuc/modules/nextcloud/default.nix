{ config, pkgs, lib, ... }:
let
  domain = "nextcloud.rfive.de";
in
{
  sops.secrets = {
    "nextcloud/dbpass" = {
      owner = "nextcloud";
      group = "nextcloud";
    };
    "nextcloud/adminpass" = {
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

  services = {
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions = {
            "DATABASE nextcloud" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [ "nextcloud" ];
    };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud25; # Use current latest nextcloud package
      hostName = "${domain}";
      https = true; # Use https for all urls
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbpassFile = config.sops.secrets."nextcloud/dbpass".path;
        adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
        adminuser = "rouven";
      };
    };

    # Enable ACME and force SSL
    nginx = {
      recommendedProxySettings = true;
      virtualHosts = {
        "${domain}" = {
          enableACME = true;
          forceSSL = true;
        };
      };
    };
  };

  # ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
