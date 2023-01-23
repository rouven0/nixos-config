{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/git";
      };
      "rfive.de" = {
        user = "fedora";
      };
      "nuc" = {
        hostname = "192.168.10.2";
        user = "root";
      };
      "git@rfive.de" = {
        match = "Host rfive.de User git";
        identityFile = "~/.ssh/git";
      };
      "git@raspi" = {
        match = "Host raspi User git";
        identityFile = "~/.ssh/git";
      };
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
      };
    };
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
