{ config, pkgs, nix-colors, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      font = {
        size = 10;
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
      window.opacity = 0.0;

      colors = {
        primary = {
          background = "#${config.colorScheme.colors.base00}";
          foreground = "#${config.colorScheme.colors.base05}";
        };
        cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        selection = {
          text = "CellForeground";
          background = "#${config.colorScheme.colors.base03}";
        };
        normal = {
          black = "#${config.colorScheme.colors.base01}";
          red = "#${config.colorScheme.colors.base08}";
          green = "#${config.colorScheme.colors.base0A}";
          yellow = "#${config.colorScheme.colors.base0B}";
          blue = "#${config.colorScheme.colors.base0D}";
          magenta = "#${config.colorScheme.colors.base0E}";
          cyan = "#${config.colorScheme.colors.base0C}";
          white = "#${config.colorScheme.colors.base05}";
        };
      };
    };
  };
}
