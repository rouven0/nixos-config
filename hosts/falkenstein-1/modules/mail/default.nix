{ config, ... }:
{
  sops.secrets."mail/rouven".owner = config.users.users.postfix.name;
  sops.secrets."rspamd".owner = config.users.users.rspamd.name;
  mailserver = rec {
    enable = true;
    fqdn = "falkenstein.vpn.rfive.de";
    domains = [ "rfive.de" ];
    loginAccounts = {
      "rouven@rfive.de" = {
        name = "Rouven Seifert";
        hashedPasswordFile = config.sops.secrets."mail/rouven".path;

      };
    };
    certificateScheme = "acme-nginx";
  };
  services.rspamd.locals."worker-controller.inc".source = config.sops.secrets."rspamd".path;
  services.nginx.virtualHosts."rspamd.rfive.de" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://unix:/run/rspamd/worker-controller.sock:/";
      };
    };
  };
}
