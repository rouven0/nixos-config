{ config, pkgs, ... }:
let
  gpg-default-key = "116987A8DD3F78FF8601BF4DB95E8FE6B11C4D09";
in
{
  home.packages = with pkgs; [
    imv
    w3m
    urlview
  ];
  services.mbsync.enable = true;
  programs = {
    neomutt = {
      enable = true;
      sidebar.enable = true;
      checkStatsInterval = 30;
      extraConfig = ''
        bind pager <Space> noop
        bind index,pager \Cp sidebar-prev
        # Move the highlight to the next mailbox
        bind index,pager \Cn sidebar-next
        # Open the highlighted mailbox
        bind index,pager <space><return> sidebar-open
        set mailcap_path = ${./mailcap}
        source ${./vim-keys.rc}
        source ${./dracula.muttrc}
        source ${./powerline.neomuttrc}
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
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/rfive";
      imap = {
        host = "pro1.mail.ovh.net";
        port = 993;
      };
      smtp = {
        host = "pro1.mail.ovh.net";
        port = 587;
        tls.useStartTls = true;
      };
      msmtp.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        groups.rfive = {
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
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/tu-dresden";
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
        expunge = "both";
        groups.tud = {
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
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "--TU Dresden-------";
        # mbsync can't handle umlauts, crap
        extraMailboxes = [ "Opal" "Sent" "Trash" "Junk-E-Mail" "Drafts" ];
      };
    };
    "gmail" = rec {
      address = "seifertrouven@gmail.com";
      realName = "Rouven Seifert";
      userName = address;
      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/email/google";
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
        groups.googlemail = {
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "[Gmail]/Papierkorb";
            extraConfig.Create = "near";
          };
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "[Gmail]/Gesendet";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "[Gmail]/Entw&APw-rfe";
            extraConfig.Create = "near";
          };
        };
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      msmtp.enable = true;
      neomutt = {
        enable = true;
        mailboxName = "--gmail------------";
        extraMailboxes = [ "Sent" "Trash" "[Gmail]/Spam" "Drafts" ];
      };
    };
  };
  home.file.".urlview".text = ''
    COMMAND google-chrome-stable %s &> /dev/null
  '';
}
