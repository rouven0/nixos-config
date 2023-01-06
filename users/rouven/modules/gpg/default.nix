{ config, ... }:
{
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    publicKeys = [
      {
        source = ../../../../keys/pgp/rouven.asc;
        trust = 5;
      }
    ];
    scdaemonSettings = { disable-ccid = true; };
  };
}
