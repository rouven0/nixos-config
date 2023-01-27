{ config, pkgs, ... }:
let
  gpg-default-key = "116987A8DD3F78FF8601BF4DB95E8FE6B11C4D09";
in
{
  home.packages = with pkgs; [
    imv
    w3m
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
        extraMailboxes = [ "Gesendete Elemente" "Opal" "Gel&APY-schte Elemente" "Junk-E-Mail" "Entw&APw-rfe" ];
        extraConfig = ''
          unset postponed
          unset trash
          unset record
          set postponed='+Entw&APw-rfe'
          set trash='+Gel&APY-schte Elemente'
          set record='+Gesendete Elemente'
        '';
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
        extraMailboxes = [ "[Gmail]/Gesendet" "[Gmail]/Papierkorb" "[Gmail]/Spam" "[Gmail]/Entw&APw-rfe" ];
        extraConfig = ''
          unset postponed
          unset trash
          unset record
          set postponed='+[Gmail]/Entw&APw-rfe'
          set trash='+[Gmail]/Papierkorb'
          set record='+[Gmail/Gesendet]'
        '';
      };
    };
  };


}
