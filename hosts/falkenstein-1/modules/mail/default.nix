{ config, pkgs, ... }:

let
  domain = "rfive.de";
  hostname = "falkenstein.vpn.${domain}";
  rspamd-domain = "rspamd.${domain}";
in
{
  networking.firewall.allowedTCPPorts = [
    25 # insecure SMTP
    465
    587 # SMTP
    993 # IMAP
    4190 # sieve
  ];
  users.users.postfix.extraGroups = [ "opendkim" ];
  users.users.rouven = {
    description = "Rouven Seifert";
    isNormalUser = true;
  };

  services = {
    postfix = {
      enable = true;
      enableSubmission = true;
      enableSubmissions = true;
      hostname = "${hostname}";
      domain = "${domain}";
      origin = "${domain}";
      destination = [ "${hostname}" "${domain}" "localhost" ];
      networks = [ "127.0.0.1" "141.30.30.169" ];
      sslCert = "/var/lib/acme/${hostname}/fullchain.pem";
      sslKey = "/var/lib/acme/${hostname}/key.pem";

      extraAliases = ''
        postmaster:     root
        abuse:          postmaster
      '';
      config = {
        home_mailbox = "Maildir/";
        smtp_use_tls = true;
        smtpd_use_tls = true;
        smtpd_tls_protocols = [
          "!SSLv2"
          "!SSLv3"
          "!TLSv1"
          "!TLSv1.1"
        ];
        smtpd_recipient_restrictions = [
          "permit_sasl_authenticated"
          "permit_mynetworks"
          "reject_unauth_destination"
          "reject_non_fqdn_sender"
          "reject_non_fqdn_recipient"
          "reject_unknown_sender_domain"
          "reject_unknown_recipient_domain"
          "reject_unauth_destination"
          "reject_unauth_pipelining"
          "reject_invalid_hostname"
        ];
        smtpd_relay_restrictions = [
          "permit_sasl_authenticated"
          "permit_mynetworks"
          "reject_unauth_destination"
        ];
        alias_maps = [ "hash:/etc/aliases" ];
        smtpd_milters = [ "local:/run/opendkim/opendkim.sock" ];
        non_smtpd_milters = [ "local:/var/run/opendkim/opendkim.sock" ];
        smtpd_sasl_auth_enable = true;
        smtpd_sasl_path = "/var/lib/postfix/auth";
        smtpd_sasl_type = "dovecot";
        mailbox_transport = "lmtp:unix:/run/dovecot2/dovecot-lmtp";

      };
    };

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
        perProtocol = {
          imap = {
            enable = [ ];
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
      };
      modules = [
        pkgs.dovecot_pigeonhole
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

    opendkim = {
      enable = true;
      domains = "csl:${domain}";
      selector = "falkenstein";
      configFile = pkgs.writeText "opendkim-config" ''
        UMask                   0117
      '';
    };
    rspamd = {
      enable = true;
      postfix.enable = true;
      locals = {
        "worker-controller.inc".text = ''
          password = "$2$g1jh7t5cxschj11set5wksd656ixd5ie$cgwrj53hfb87xndqbh5r3ow9qfi1ejii8dxok1ihbnhamccn1rxy";
        '';
        "redis.conf".text = ''
          read_servers = "127.0.0.1";
          write_servers = "127.0.0.1";
        '';
      };
    };
    redis = {
      vmOverCommit = true;
      servers.rspamd = {
        enable = true;
        port = 6379;
      };
    };
  };
  security.acme.certs."${domain}" = {
    reloadServices = [
      "postfix.service"
      "dovecot2.service"
    ];
  };

  services.nginx.virtualHosts = {
    "${hostname}" = {
      enableACME = true;
      forceSSL = true;
    };
    "rspamd.rfive.de" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:11334";
          proxyWebsockets = true;
        };
      };
    };
  };
}
