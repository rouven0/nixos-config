{ config, pkgs, ... }:

let
  domain = "rfive.de";
  hostname = "falkenstein.vpn.${domain}";
  # see https://www.kuketz-blog.de/e-mail-anbieter-ip-stripping-aus-datenschutzgruenden/
  header_cleanup = pkgs.writeText "header_cleanup_outgoing" ''
    /^\s*(Received: from)[^\n]*(.*)/ REPLACE $1 127.0.0.1 (localhost [127.0.0.1])$2
    /^\s*User-Agent/ IGNORE
    /^\s*X-Enigmail/ IGNORE
    /^\s*X-Mailer/ IGNORE
    /^\s*X-Originating-IP/ IGNORE
    /^\s*Mime-Version/ IGNORE
  '';
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
  environment.etc = {
    "dovecot/sieve-pipe/sa-learn-spam.sh" = {
      text = ''
        #!/bin/sh
        ${pkgs.rspamd}/bin/rspamc learn_spam
      '';
      mode = "0555";
    };
    "dovecot/sieve-pipe/sa-learn-ham.sh" = {
      text = ''
        #!/bin/sh
        ${pkgs.rspamd}/bin/rspamc learn_ham
      '';
      mode = "0555";
    };
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
        smtp_header_checks = "pcre:${header_cleanup}";
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
            enable = [ "imap_sieve" ];
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

          plugin {
            sieve_plugins = sieve_imapsieve sieve_extprograms
            sieve_global_extensions = +vnd.dovecot.pipe
            sieve_pipe_bin_dir = /etc/dovecot/sieve-pipe

            # Spam: From elsewhere to Spam folder or flag changed in Spam folder
            imapsieve_mailbox1_name = Spam
            imapsieve_mailbox1_causes = COPY APPEND FLAG
            imapsieve_mailbox1_before = file:/var/lib/dovecot/imap_sieve/report-spam.sieve

            # Ham: From Spam folder to elsewhere
            imapsieve_mailbox2_name = *
            imapsieve_mailbox2_from = Spam
            imapsieve_mailbox2_causes = COPY
            imapsieve_mailbox1_before = file:/var/lib/dovecot/imap_sieve/report-ham.sieve
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
