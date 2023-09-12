{ config, ... }:
{
  sops.secrets."pfersel/token".owner = "pfersel";
  services.pfersel = {
    enable = true;
    discord = {
      tokenFile = config.sops.secrets."pfersel/token".path;
    };
  };
}
