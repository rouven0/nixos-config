{ pkgs, lib, ... }:
let
  gpg-default-key = "116987A8DD3F78FF8601BF4DB95E8FE6B11C4D09";
in
{
  sops.secrets = {
    "email/rfive" = { };
    "email/tu-dresden" = { };
    "email/ifsr" = { };
    "email/agdsn" = { };
    "email/google" = { };
  };
  home.packages = with pkgs; [
    imv
    w3m
    urlview
  ];
  programs = {
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
        source ${./vim-keys.muttrc}
        source ${./dracula.muttrc}
        source ${./powerline.muttrc}
      '';
    };
    # set sidebar_indent_string = '  '
    # set sidebar_width = 80
    # set sidebar_folder_indent = yes
    mbsync.enable = true;
  };
  accounts.email.accounts = {
    "rouven@rfive.de" = rec {
      address = "rouven@rfive.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = address;
      passwordCommand = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/email/rfive";
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
        groups.rfive = {
          channels.inbox = {
            nearPattern = "INBOX";
            farPattern = "INBOX";
            extraConfig.Create = "near";
          };
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "Trash";
            extraConfig.Create = "near";
          };
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "Sent";
            extraConfig.Create = "near";
          };
          channels.junk = {
            nearPattern = "Spam";
            farPattern = "Spam";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "Drafts";
            extraConfig.Create = "near";
          };
          channels.github = {
            nearPattern = "GitHub";
            farPattern = "GitHub";
            extraConfig.Create = "near";
          };
          channels.reports = {
            nearPattern = "Reports";
            farPattern = "Reports";
            extraConfig.Create = "near";
          };
        };
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      neomutt = let c = mbsync.groups.rfive.channels; in
        {
          enable = true;
          mailboxName = " 󰒋 rfive.de";
          extraMailboxes = lib.lists.forEach [ c.sent c.trash c.junk c.drafts c.reports c.github ] (x: x.nearPattern);
        };
    };
    "TU-Dresden" = rec {
      address = "rouven.seifert@mailbox.tu-dresden.de";
      gpg.key = gpg-default-key;
      realName = "Rouven Seifert";
      userName = "rose159e";
      passwordCommand = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/email/tu-dresden";
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
      neomutt = let c = mbsync.groups.tud.channels; in
        {
          enable = true;
          mailboxName = "  TU Dresden";
          extraMailboxes = lib.lists.forEach [ c.opal c.sent c.trash c.junk c.drafts ] (x: x.nearPattern);
        };
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
      passwordCommand = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/email/ifsr";
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
        groups.ifsr = {
          # TODO beautify with nix magic
          channels.inbox = {
            nearPattern = "INBOX";
            farPattern = "INBOX";
            extraConfig.Create = "near";
          };
          channels.root = {
            nearPattern = "Root";
            farPattern = "Root";
            extraConfig.Create = "near";
          };
          channels.ese = {
            nearPattern = "ESE";
            farPattern = "ESE";
            extraConfig.Create = "near";
          };
          channels.github = {
            nearPattern = "GitHub";
            farPattern = "GitHub";
            extraConfig.Create = "near";
          };
          channels.reports = {
            nearPattern = "Reports";
            farPattern = "Reports";
            extraConfig.Create = "near";
          };
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "Trash";
            extraConfig.Create = "near";
          };
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "Sent";
            extraConfig.Create = "near";
          };
          channels.junk = {
            nearPattern = "Spam";
            farPattern = "Spam";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "Drafts";
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
      neomutt = let c = mbsync.groups.ifsr.channels; in
        {
          enable = true;
          mailboxName = "  iFSR";
          extraMailboxes = lib.lists.forEach [ c.root c.ese c.github c.reports c.sent c.trash c.junk c.drafts ] (x: x.nearPattern);
        };
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
      passwordCommand = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/email/agdsn";
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
        groups.ifsr = {
          channels.inbox = {
            nearPattern = "INBOX";
            farPattern = "INBOX";
            extraConfig.Create = "near";
          };
          channels.trash = {
            nearPattern = "Trash";
            farPattern = "Trash";
            extraConfig.Create = "near";
          };
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "Sent";
            extraConfig.Create = "near";
          };
          channels.junk = {
            nearPattern = "Junk";
            farPattern = "Junk";
            extraConfig.Create = "near";
          };
          channels.drafts = {
            nearPattern = "Drafts";
            farPattern = "Drafts";
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
      neomutt = let c = mbsync.groups.ifsr.channels; in
        {
          enable = true;
          mailboxName = " 󰒍 AG DSN";
          extraMailboxes = lib.lists.forEach [ c.sent c.trash c.junk c.drafts ] (x: x.nearPattern);
        };
    };
    "gmail" = rec {
      address = "seifertrouven@gmail.com";
      realName = "Rouven Seifert";
      userName = address;
      passwordCommand = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/email/google";
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
          channels.sent = {
            nearPattern = "Sent";
            farPattern = "[Gmail]/Gesendet";
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
        };
        extraConfig = {
          account = {
            AuthMechs = "Login";
          };
        };
      };
      thunderbird.enable = true;
      neomutt = let c = mbsync.groups.gmail.channels; in
        {
          enable = true;
          mailboxName = " 󰊫 gmail";
          extraMailboxes = lib.lists.forEach [ c.sent c.trash c.junk c.drafts ] (x: x.nearPattern);
          extraConfig = ''
            set copy = no
          '';
        };
    };
  };
  home.file.".urlview".text = ''
    COMMAND ${pkgs.xdg-utils}/bin/xdg-open %s &> /dev/null
  '';
  home.file.".gnupg/dirmngr_ldapservers.conf".text = ''
    ldap.pca.dfn.de::::o=DFN-Verein,c=DE
  '';
}
