{ config, pkgs, ... }:
let
  domain = "nextcloud.${config.networking.domain}";
in
{
  sops.secrets = {
    "nextcloud/adminpass" = {
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27; # Use current latest nextcloud package
      hostName = "${domain}";
      https = true; # Use https for all urls
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
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
  systemd.services."nextcloud-cron" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
