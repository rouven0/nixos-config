{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Rouven Seifert";
    userEmail = "rouven@rfive.de";
    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
    extraConfig = {
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      user.signingkey = "B95E8FE6B11C4D09";
      pull.rebase = false;
      init.defaultBranch = "main";
      commit.gpgsign = true;
      sendemail = {
        from = "Rouven Seifert <rouven@rfive.de>";
        smtpEncryption = "ssl";
        smtpServer = "mail.rfive.de";
        smteServerPort = 465;
        smtpSslCertPath = "/etc/ssl/certs/ca-certificates.crt";
        smtpUser = "rouven";
      };
    };
  };
  programs.gh = {
    enable = true;
    settings = {
      editor = "hx";
      git_protocol = "ssh";
    };
  };
}
