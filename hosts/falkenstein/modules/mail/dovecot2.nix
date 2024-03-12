{ config, pkgs, lib, ... }:
let
  hostname = "mail.${config.networking.domain}";
in
{
  networking.firewall.allowedTCPPorts = [
    993
    4190
  ];
  services = {
    dovecot2 = {
      enable = true;
      enableImap = true;
      enableQuota = false;
      enableLmtp = true;
      mailLocation = "maildir:~/Maildir";
      sslServerCert = "/var/lib/acme/${hostname}/fullchain.pem";
      sslServerKey = "/var/lib/acme/${hostname}/key.pem";
      protocols = [ "imap" "sieve" ];
      mailPlugins = {
        globally.enable = [ "listescape" ];
        perProtocol = {
          imap = {
            enable = [ "imap_sieve" "imap_filter_sieve" ];
          };
          lmtp = {
            enable = [ "sieve" ];
          };
        };
      };
      mailboxes = {
        Spam = {
          auto = "create";
          specialUse = "Junk";
        };
        Sent = {
          auto = "create";
          specialUse = "Sent";
        };
        Drafts = {
          auto = "create";
          specialUse = "Drafts";
        };
        Trash = {
          auto = "create";
          specialUse = "Trash";
        };
        Archive = {
          auto = "no";
          specialUse = "Archive";
        };
      };
      modules = [
        pkgs.dovecot_pigeonhole
      ];
      sieve = {
        # just pot something in here to prevent empty strings
        extensions = [ "notify" ];
        # globalExtensions = [ "+vnd.dovecot.pipe" ];
        pipeBins = map lib.getExe [
          (pkgs.writeShellScriptBin "learn-ham.sh" "exec ${pkgs.rspamd}/bin/rspamc learn_ham")
          (pkgs.writeShellScriptBin "learn-spam.sh" "exec ${pkgs.rspamd}/bin/rspamc learn_spam")
        ];
        plugins = [
          "sieve_imapsieve"
          "sieve_extprograms"
        ];
      };
      imapsieve.mailbox = [
        {
          # Spam: From elsewhere to Spam folder or flag changed in Spam folder
          name = "Spam";
          causes = [ "COPY" "APPEND" "FLAG" ];
          before = ./report-spam.sieve;

        }
        {
          # From Junk folder to elsewhere
          name = "*";
          from = "Spam";
          causes = [ "COPY" ];
          before = ./report-ham.sieve;
        }
      ];
      extraConfig = ''
        auth_username_format = %Ln
        userdb {
          driver = passwd
          args = blocking=no
        }
        service auth {
          unix_listener /var/lib/postfix/auth {
            group = postfix
            mode = 0660
            user = postfix
           }
         }
        service managesieve-login {
          inet_listener sieve {
            port = 4190
          }
        
          service_count = 1
        }
        namespace inbox {
          separator = /
          inbox = yes
        }
        service lmtp {
          unix_listener dovecot-lmtp {
            group = postfix
            mode = 0600
            user = postfix
          }
          client_limit = 1
        }
      '';
    };
  };
}
