{ ... }:
let
  git = "~/.ssh/git";
in
{
  programs.ssh = rec {
    enable = true;
    matchBlocks = {
      "artemis-git.inf.tu-dresden.de" = {
        identityFile = git;
      };
      "se-gitlab.inf.tu-dresden.de" = {
        identityFile = git;
      };
      "github.com" = {
        identityFile = git;
      };
      "rfive.de" = {
        user = "root";
        port = 2222;
      };
      falkenstein-1 = matchBlocks."rfive.de";
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
