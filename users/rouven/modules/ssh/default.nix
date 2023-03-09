{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "se-gitlab.inf.tu-dresden.de" = {
        identityFile = "~/.ssh/git";
      };
      "github.com" = {
        identityFile = "~/.ssh/git";
      };
      "rfive.de" = {
        user = "debian";
      };
      "kaki" = {
        hostname = "kaki.ifsr.de";
        user = "root";
      };
      "fsr" = {
        hostname = "ifsr.de";
        user = "rouven.seifert";
      };
      "quitte" = {
        hostname = "quitte.ifsr.de";
        user = "root";
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
      "git@ifsr.de" = {
        match = "Host ifsr.de User git";
        identityFile = "~/.ssh/git";
      };
    };
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
