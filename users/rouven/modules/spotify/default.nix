{ config, pkgs, ... }:
{
  home.packages = [ pkgs.spotify-tui ];
  sops.secrets."spotify" = { };
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = config.accounts.email.accounts."gmail".address;
        password_cmd = "${pkgs.coreutils}/bin/cat $XDG_RUNTIME_DIR/secrets/spotify";
      };
    };
  };
  systemd.user.services.spotifyd.Unit.After = [ "sops-nix.service" ];
}
