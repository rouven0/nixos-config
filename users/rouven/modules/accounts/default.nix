{ config, ... }:
let
  gpg-default-key = "116987A8DD3F78FF8601BF4DB95E8FE6B11C4D09";
in
{
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        withExternalGnupg = true;
        isDefault = true;
      };
    };
  };
  accounts.email.accounts = {
    "rouven@rfive.de" = rec {
      primary = true;
      address = "rouven@rfive.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = address;
      imap = {
        host = "pro1.mail.ovh.net";
        port = 993;
      };
      smtp = {
        host = "pro1.mail.ovh.net";
        port = 587;
      };
      thunderbird.enable = true;
    };
    "TU Dresden" = {
      address = "rouven.seifert@mailbox.tu-dresden.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "user\\rose159e";
      imap = {
        host = "msx.tu-dresden.de";
        port = 993;
      };
      smtp = {
        host = "msx.tu-dresden.de";
        port = 587;
      };
      thunderbird.enable = true;
    };
    GMail = rec {
      address = "seifertrouven@gmail.com";
      realName = "Rouven Seifert";
      userName = address;
      imap = {
        host = "imap.gmail.com";
        port = 993;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
      };
      thunderbird.enable = true;
    };
  };
}
