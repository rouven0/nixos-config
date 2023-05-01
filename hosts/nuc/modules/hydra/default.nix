{ config, ... }:
let
  domain = "hydra.rfive.de";
in
{
  services.hydra = {
    enable = true;
    port = 4000;
    hydraURL = domain;
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;

  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
    };
  };
}
