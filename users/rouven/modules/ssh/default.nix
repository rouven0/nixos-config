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
      "git@rfive.de" = {
        match = "Host rfive.de User git";
        identityFile = "~/.ssh/git";
      };
      "git@raspi" = {
        match = "Host raspi User git";
        identityFile = "~/.ssh/git";
      };
    };
  };
}
