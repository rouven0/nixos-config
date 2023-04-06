{ config, ... }:
let
  git = "~/.ssh/git";
in
{
  programs.ssh = rec {
    enable = true;
    matchBlocks = {
      "se-gitlab.inf.tu-dresden.de" = {
        identityFile = git;
      };
      "github.com" = {
        identityFile = git;
      };
      "rfive.de" = {
        user = "debian";
      };
      "kaki" = {
        hostname = "kaki.ifsr.de";
        user = "root";
      };
      "ifsr" = {
        hostname = "ifsr.de";
        user = "rouven.seifert";
      };
      "fsr" = matchBlocks."ifsr";
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
        identityFile = git;
      };
      "git@raspi" = {
        match = "Host raspi User git";
        identityFile = git;
      };
      "git@ifsr.de" = {
        match = "Host ifsr.de User git";
        identityFile = git;
      };
    };
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
