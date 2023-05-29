{ config, ... }:
let
  domain = "purge.rfive.de";
in
{
  sops.secrets."purge/environment".owner = "purge";
  services.purge = {
    enable = true;
    discord = {
      clientId = "941041925216157746";
      publicKey = "d2945f6130d9b4a8dda8c8bf52db5dee127a82f89c6b8782e84aa8f45f61d402";
    };
    environmentFile = config.sops.secrets."purge/environment".path;
  };
  services.nginx.virtualHosts."${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.purge.listenPort}";
    };
  };
}
