{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    clock24 = true;
    extraConfig =
      ''
        set -g default-shell ${pkgs.zsh}/bin/zsh
        bind P display-popup
        set -sg escape-time 10
        set -g @dracula-plugins "git time"
        set -g @dracula-show-left-icon session
        set -g @dracula-show-powerline true
        run-shell ${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/dracula/dracula.tmux
      '';
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
    ];
  };

}
