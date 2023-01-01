{ config, ... }:
{
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
}
