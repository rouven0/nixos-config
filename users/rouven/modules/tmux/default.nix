{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    clock24 = true;
    extraConfig =
      ''
        set -g default-shell /etc/profiles/per-user/rouven/bin/zsh
        bind P display-popup
      '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-fahrenheit false
          set -g @dracula-plugins "weather time"
          set -g @dracula-show-left-icon session
          set -g @dracula-show-powerline true
        '';
      }
      tmux-fzf
    ];
  };

}
