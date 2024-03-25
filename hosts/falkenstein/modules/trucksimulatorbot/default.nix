{ config, pkgs, ... }:
let
  domain = "trucks.${config.networking.domain}";
in
{
  services.trucksimulatorbot = {
    inherit domain;
    enable = true;
    discord = {
      clientId = "831052837353816066";
      publicKey = "faa7004a2a5096702f96f3ebeb45c7e8272c119b72c1a0894abc4d76d8cc8bad";
    };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureUsers = [
      {
        name = "trucksimulator";
        ensurePermissions = {
          "trucksimulator.*" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "trucksimulator" ];
  };
}
