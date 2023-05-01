{ pkgs, ... }:
{
  programs.command-not-found.enable = false;
  environment.systemPackages = with pkgs; [
    fzf
  ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=#00bbbb,bold";
    };

    shellInit =
      ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zsh-newuser-install () {}

      '';

    # Hacky way to bind Ctrl+R to fzf. Otherwise it will be overridden 
    promptInit =
      ''
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';
  };
}

