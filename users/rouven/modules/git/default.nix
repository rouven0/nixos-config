{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Rouven Seifert";
    userEmail = "rouven@rfive.de";
    extraConfig = {
      core.pager = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
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
