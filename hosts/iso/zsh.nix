{ pkgs, ... }:
{
  programs.command-not-found.enable = false;
  users.defaultUserShell = pkgs.zsh;
  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=#00bbbb,bold";
    };
    ohMyZsh = {
      enable = true;
      theme = "risto";
    };

    shellInit =
      ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zsh-newuser-install () {}
      '';
  };
}

