{ config, ... }:
let
  domain = "mail.${config.networking.domain}";
in
{
  imports = [
    ./postfix.nix
    ./dovecot2.nix
    ./rspamd.nix
  ];
  security.acme.certs."${domain}" = {
    reloadServices = [
      "postfix.service"
      "dovecot2.service"
    ];
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
