{ config, pkgs, ... }:

let
  domain = config.networking.domain;
  hostname = "mail.${domain}";
  header_cleanup = pkgs.writeText "header_cleanup_outgoing" ''
    /^\s*(Received: from)[^\n]*(.*)/ REPLACE $1 127.0.0.1 (localhost [127.0.0.1])$2
    /^\s*User-Agent/ IGNORE
    /^\s*X-Enigmail/ IGNORE
    /^\s*X-Mailer/ IGNORE
    /^\s*X-Originating-IP/ IGNORE
    /^\s*Mime-Version/ IGNORE
  '';
  login_maps = pkgs.writeText "login_maps.pcre" ''
    # basic username => username@rfive.de
    /^([^@+]*)(\+[^@]*)?@rfive\.de$/ ''${1}
  '';
in
{
  networking.firewall.allowedTCPPorts = [
    25 # SMTP
    465 # SUBMISSONS
  ];

  services = {
    postfix = {
      enable = true;
      enableSubmission = true;
      enableSubmissions = true;
      recipientDelimiter = "+";
      hostname = "${hostname}";
      domain = "${domain}";
      origin = "${domain}";
      destination = [ "${hostname}" "${domain}" "localhost" ];
      networks = [ "127.0.0.1" ];
      sslCert = "/var/lib/acme/${hostname}/fullchain.pem";
      sslKey = "/var/lib/acme/${hostname}/key.pem";
      config = {
        home_mailbox = "Maildir/";
        smtp_helo_name = config.networking.fqdn;
        smtpd_banner = "${config.networking.fqdn} ESMTP $mail_name";
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
        smtpd_sender_restrictions = [
          "reject_authenticated_sender_login_mismatch"
        ];
        smtpd_sender_login_maps = [ "pcre:${login_maps}" ];
        smtp_header_checks = "pcre:${header_cleanup}";

        alias_maps = [ "hash:/etc/aliases" ];
        smtpd_sasl_auth_enable = true;
        smtpd_sasl_path = "/var/lib/postfix/auth";
        smtpd_sasl_type = "dovecot";
        mailbox_transport = "lmtp:unix:/run/dovecot2/dovecot-lmtp";
      };
    };
  };
}
