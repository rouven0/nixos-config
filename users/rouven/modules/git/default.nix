{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Rouven Seifert";
    userEmail = "rouven@rfive.de";
    extraConfig = {
      user.signingkey = "B95E8FE6B11C4D09";
      pull.rebase = false;
      init.defaultBranch = "main";
      commit.gpgsign = true;
    };
  };
}
