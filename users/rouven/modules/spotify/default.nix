{ config, pkgs, ... }:
{
  home.packages = [ pkgs.spotify-tui ];
  age.secrets.spotify = {
    file = ../../../../secrets/rouven/spotify.age;
  };
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = config.accounts.email.accounts."gmail".address;
        password_cmd = "${pkgs.coreutils}/bin/cat ${config.age.secrets.spotify.path}";
      };
      backend = "pulseaudio";
    };
  };
  systemd.user.services.spotifyd.Unit.After = [ "agenix.service" ];
}
