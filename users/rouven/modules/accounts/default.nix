{ config, pkgs, ... }:
let
  gpg-default-key = "116987A8DD3F78FF8601BF4DB95E8FE6B11C4D09";
in
{
  age.secrets = {
    "mail/rfive".file = ../../../../secrets/rouven/mail/rfive.age;
    "mail/tu-dresden".file = ../../../../secrets/rouven/mail/tu-dresden.age;
    "mail/ifsr".file = ../../../../secrets/rouven/mail/ifsr.age;
    "mail/agdsn".file = ../../../../secrets/rouven/mail/agdsn.age;
    "mail/google".file = ../../../../secrets/rouven/mail/google.age;
  };
  programs = {
    aerc = {
      enable = true;
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
        };
        ui = {
          sort = "date";
          dirlist-tree = true;
          fuzzy-complete = true;
          styleset-name = "dracula";
          threading-enabled = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/html" = "html | colorize";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/calendar" = "calendar";
        };
      };

    };
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          withExternalGnupg = true;
          isDefault = true;
          settings = {
            "intl.date_time.pattern_override.connector_short" = "{1} {0}";
            "intl.date_time.pattern_override.date_short" = "yyyy-MM-dd";
            "intl.date_time.pattern_override.time_short" = "HH:mm";
          };
        };
      };
    };
    mbsync.enable = true;
  };
  accounts.email.accounts = {
    "rouven@rfive.de" = rec {
      address = "rouven@rfive.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = address;
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/rfive".path}";
      imap = {
        host = "mail.rfive.de";
        port = 993;
      };
      smtp = {
        host = "mail.rfive.de";
        port = 465;
      };
      thunderbird.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      aerc.enable = true;
    };
    "TU-Dresden" = rec {
      address = "rouven.seifert@mailbox.tu-dresden.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "rose159e";
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/tu-dresden".path}";
      imap = {
        host = "msx.tu-dresden.de";
        port = 993;
      };
      smtp = {
        host = "msx.tu-dresden.de";
        port = 587;
        tls.useStartTls = true;
      };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        groups.tud = {
          channels.inbox = {
            nearPattern = "INBOX";
            farPattern = "INBOX";
            extraConfig.Create = "near";
          };
          channels.opal = {
            nearPattern = "Opal";
            farPattern = "Opal";
            extraConfig.Create = "near";
          };
          channels.FSR = {
            nearPattern = "FSR";
            farPattern = "FSR";
            extraConfig.Create = "near";
          };
          channels.unispam = {
            nearPattern = "Uni Spam";
            farPattern = "Uni Spam";
            extraConfig.Create = "near";
          };
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "Gel&APY-schte Elemente";
            extraConfig.Create = "near";
          };
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "Gesendete Elemente";
            extraConfig.Create = "near";
          };
          channels.junk = {
            nearPattern = "Junk";
            farPattern = "Junk-E-Mail";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "Entw&APw-rfe";
            extraConfig.Create = "near";
          };
        };
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      thunderbird.enable = true;
      aerc.enable = true;
    };
    "iFSR" = rec {
      address = "rouven.seifert@ifsr.de";
      signature = {
        showSignature = "append";
        text = ''
          Rouven Seifert

          Co-Admin im Fachschaftsrat Informatik TU Dresden
          Fakultät Informatik
          Nöthnitzer Str. 46, 01187 Dresden
        '';
      };
      primary = true;
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "rouven.seifert";
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/ifsr".path}";
      imap = {
        host = "mail.ifsr.de";
        port = 993;
      };
      smtp = {
        host = "mail.ifsr.de";
        port = 465;
      };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      thunderbird.enable = true;
      aerc.enable = true;
    };
    "agdsn" = rec {
      address = "r5@agdsn.me";
      # gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "r5@agdsn.me";
      aliases = [
        "r5@agdsn.de"
        "rouven.seifert@agdsn.de"
      ];
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/agdsn".path}";
      imap = {
        host = "imap.agdsn.de";
        port = 993;
      };
      smtp = {
        host = "smtp.agdsn.de";
        port = 465;
      };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      thunderbird.enable = true;
      aerc.enable = true;
    };
    "gmail" = rec {
      address = "seifertrouven@gmail.com";
      realName = "Rouven Seifert";
      userName = address;
      passwordCommand = "${pkgs.coreutils}/bin/cat ${config.age.secrets."mail/google".path}";
      imap = {
        host = "imap.gmail.com";
        port = 993;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 465;
      };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        groups.gmail = {
          channels.inbox = {
            nearPattern = "INBOX";
            farPattern = "INBOX";
            extraConfig.Create = "near";
          };
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "[Gmail]/Papierkorb";
            extraConfig.Create = "near";
          };
          channels.junk = {
            nearPattern = "Junk";
            farPattern = "[Gmail]/Spam";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "[Gmail]/Entw&APw-rfe";
            extraConfig.Create = "near";
          };
          channels.hetzner = {
            nearPattern = "Hetzner";
            farPattern = "Hetzner";
            extraConfig.Create = "near";
          };
          channels.studentenwerk = {
            nearPattern = "Studentenwerk";
            farPattern = "Studentenwerk";
            extraConfig.Create = "near";
          };
        };
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      thunderbird.enable = true;
      aerc.enable = true;
    };
  };
  home.file.".gnupg/dirmngr_ldapservers.conf".text = ''
    ldap.pca.dfn.de::::o=DFN-Verein,c=DE
  '';
}
