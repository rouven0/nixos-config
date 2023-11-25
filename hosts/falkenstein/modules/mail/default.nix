{ config, pkgs, ... }:

let
  domain = config.networking.domain;
  hostname = "mail.${domain}";
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
    25 # SMTP
    465 # SUBMISSONS
    993 # IMAPS
    4190 # sieve
  ];
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
    "dovecot/sieve/report-spam.sieve" = {
      source = ./report-spam.sieve;
      user = "dovecot2";
      group = "dovecot2";
      mode = "0544";
    };
    "dovecot/sieve/report-ham.sieve" = {
      source = ./report-ham.sieve;
      user = "dovecot2";
      group = "dovecot2";
      mode = "0544";
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
      config = {
        home_mailbox = "Maildir/";
        smtp_helo_name = "falkenstein.vpn.rfive.de";
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
        plugin {
          sieve_plugins = sieve_imapsieve sieve_extprograms
          sieve_global_extensions = +vnd.dovecot.pipe
          sieve_pipe_bin_dir = /etc/dovecot/sieve-pipe

          # Spam: From elsewhere to Spam folder or flag changed in Spam folder
          imapsieve_mailbox1_name = Spam
          imapsieve_mailbox1_causes = COPY APPEND FLAG
          imapsieve_mailbox1_before = file:/etc/dovecot/sieve/report-spam.sieve

          # From Junk folder to elsewhere
          imapsieve_mailbox2_name = *
          imapsieve_mailbox2_from = Spam
          imapsieve_mailbox2_causes = COPY
          imapsieve_mailbox2_before = file:/etc/dovecot/sieve/report-ham.sieve

        }
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
        "milter_headers.conf".text = ''
          use = ["x-spam-level", "x-spam-status", "x-spamd-result", "authentication-results" ];
        '';
        "dmarc.conf".text = ''
          reporting {
            # Required attributes
            enabled = true; # Enable reports in general
            email = 'reports@${config.networking.domain}'; # Source of DMARC reports
            domain = '${config.networking.domain}'; # Domain to serve
            org_name = '${config.networking.domain}'; # Organisation
            from_name = 'DMARC Aggregate Report';
          }
        '';
        "dkim_signing.conf".text = ''
          selector = "rspamd";
          allow_username_mismatch = true;
          domain {
            rfive.de {
              path = /var/lib/rspamd/dkim/rfive.key;
              selector = "rspamd";
            }
          }
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
    "rspamd.${config.networking.domain}" = {
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
  systemd = {
    services.rspamd-dmarc-report = {
      description = "rspamd dmarc reporter";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.rspamd}/bin/rspamadm dmarc_report -v";
        User = "rspamd";
        Group = "rspamd";
      };
    };
    timers.rspamd-dmarc-report = {
      description = "Timer for daily dmarc reports";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Unit = "rspamd-dmarc-report.service";
      };

    };

  };
}
