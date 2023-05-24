{ config, ... }:
{
  sops.secrets."mail/rouven".owner = config.users.users.postfix.name;
  mailserver = rec {
    enable = true;
    fqdn = "mail.rfive.de";
    domains = [ "rfive.de" ];
    loginAccounts = {
      "rouven@rfive.de" = {
        name = "Rouven Seifert";
        hashedPasswordFile = config.sops.secrets."mail/rouven".path;

      };
    };
    certificateScheme = 3;
  };
}
