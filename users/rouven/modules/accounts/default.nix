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
  programs = {
    neomutt = {
      enable = true;
      sidebar.enable = true;
      extraConfig = ''
        source ${./dracula.muttrc}
      '';
    };
    mbsync.enable = true;
    msmtp.enable = true;
  };
  accounts.email.accounts = {
    "rouven@rfive.de" = rec {
      primary = true;
      address = "rouven@rfive.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = address;
      # we use pass here since bitwarden's password input can't be reached frow within neomutt
      # maybe we can replace this with sops as soon as the home manager module is merged
      passwordCommand = "pass mail/rouven@rfive.de";
      imap = {
        host = "pro1.mail.ovh.net";
        port = 993;
      };
      smtp = {
        host = "pro1.mail.ovh.net";
        port = 587;
        tls.useStartTls = true;
      };
      thunderbird.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
        subFolders = "Verbatim";
      };
      neomutt = {
        enable = true;
        mailboxName = "--rouven@rfive.de--";
        extraMailboxes = [ "Sent" "Trash" "Junk-E-Mail" "Drafts" ];
      };
    };
    "TU-Dresden" = {
      address = "rouven.seifert@mailbox.tu-dresden.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "rose159e";
      passwordCommand = "pass mail/tu-dresden";
      imap = {
        host = "msx.tu-dresden.de";
        port = 993;
      };
      smtp = {
        host = "msx.tu-dresden.de";
        port = 587;
        tls.useStartTls = true;
      };
      thunderbird.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
        subFolders = "Verbatim";
      };
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "--TU Dresden-------";
        extraMailboxes = [ "Sent" "Opal" "Trash" "Junk-E-Mail" "Drafts" ];
      };
    };
  };
}
