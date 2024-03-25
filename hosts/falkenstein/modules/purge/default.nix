{ config, ... }:
let
  domain = "purge.${config.networking.domain}";
in
{
  age.secrets.purge = {
    file = ../../../../secrets/falkenstein/purge.age;
  };
  services.purge = {
    inherit domain;
    enable = true;
    discord = {
      clientId = "941041925216157746";
      publicKey = "d2945f6130d9b4a8dda8c8bf52db5dee127a82f89c6b8782e84aa8f45f61d402";
      tokenFile = config.age.secrets.purge.path;
    };
  };
}
