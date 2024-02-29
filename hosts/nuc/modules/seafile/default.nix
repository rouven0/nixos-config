{ config, pkgs, ... }:
let
  domain = "seafile.${config.networking.domain}";
in
{
  services.seafile = {
    enable = true;
    adminEmail = "rouven@rfive.de";
    initialAdminPassword = "unused garbage";
    ccnetSettings.General.SERVICE_URL = "https://${domain}";
    ccnetSettings.General.FILE_SERVER_ROOT = "https://${domain}/seafhttp";
    seafileSettings.fileserver.port = 8083;
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:/run/seahub/gunicorn.sock";
    };
    locations."/seafhttp" = {
      proxyPass = "http://127.0.0.1:${toString config.services.seafile.seafileSettings.fileserver.port}";
      extraConfig = ''
        rewrite ^/seafhttp(.*)$ $1 break;
      '';
    };
    locations."/media" = {
      root = pkgs.seahub;
    };
  };
}
