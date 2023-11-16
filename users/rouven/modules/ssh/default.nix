{ ... }:
let
  git = "/run/user/1000/secrets/ssh/git/private";
in
{
  sops.secrets = {
    "ssh/git/private" = { };
  };
  programs.ssh = rec {
    enable = true;
    compression = true;
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
        hostname = "falkenstein.vpn.rfive.de";
        user = "root";
        port = 2222;
        extraOptions = {
          VerifyHostKeyDNS = "ask";
        };
      };
      falkenstein-1 = matchBlocks."rfive.de";
      "durian" = {
        hostname = "durian.ifsr.de";
        user = "root";
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
      "tomate" = {
        hostname = "tomate.ifsr.de";
        user = "root";
      };
      "nuc" = {
        hostname = "192.168.42.2";
        user = "root";
      };
      "router" = matchBlocks."cudy";
      "cudy" = {
        hostname = "192.168.42.1";
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
      "git@git.agdsn.de" = {
        match = "Host git.agdsn.de User git";
        identityFile = git;
      };
    };
    extraConfig = ''
      PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
      IdentityFile ~/.ssh/id_ed25519
      VisualHostKey = yes
    '';
  };
}
