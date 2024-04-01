{ ... }:
let
  git = "~/.ssh/git";
in
{
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
    extraConfig = ''
      CanonicalizeHostname yes
      CanonicalDomains agdsn.network vpn.rfive.de
      PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
      IdentityFile ~/.ssh/id_ed25519
      VisualHostKey = yes
    '';
    matchBlocks = {
      # personal use
      "git@github.com" = {
        match = "Host github.com User git";
        identityFile = git;
      };
      # iFSR
      "fsr" = {
        hostname = "ifsr.de";
        user = "rouven.seifert";
      };
      "quitte" = {
        hostname = "quitte.ifsr.de";
        user = "root";
        extraOptions = {
          RequestTTY = "yes";
          RemoteCommand = "zsh -i";
        };
      };
      "quitte-notty" = {
        hostname = "quitte.ifsr.de";
        user = "root";
      };
      "tomate" = {
        hostname = "tomate.ifsr.de";
        user = "root";
        extraOptions = {
          RequestTTY = "yes";
          RemoteCommand = "zsh -i";
        };
      };
      "tomate-notty" = {
        hostname = "tomate.ifsr.de";
        user = "root";
      };
      "git@ifsr.de" = {
        match = "Host ifsr.de User git";
        identityFile = git;
      };

      # AG DSN
      "dijkstra" = {
        hostname = "login.agdsn.tu-dresden.de";
        user = "r5";
        extraOptions = {
          VerifyHostKeyDNS = "yes";
        };
      };
      "*.agdsn.network" = {
        user = "r5";
        extraOptions = {
          ProxyJump = "dijkstra";
          VerifyHostKeyDNS = "yes";
        };
      };
      "*.vpn.rfive.de" = {
        user = "root";
      };
      "git@git.agdsn.de" = {
        match = "Host git.agdsn.de User git";
        identityFile = git;
      };
    };
  };
}
