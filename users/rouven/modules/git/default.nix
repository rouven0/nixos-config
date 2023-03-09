{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ delta ];
  programs.git = {
    enable = true;
    userName = "Rouven Seifert";
    userEmail = config.accounts.email.accounts."TU-Dresden".address;
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      user.signingkey = "B95E8FE6B11C4D09";
      pull.rebase = false;
      init.defaultBranch = "main";
      commit.gpgsign = true;
    };
  };
  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  };
}
