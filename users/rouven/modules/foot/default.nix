{ config, pkgs, nix-colors, ... }:
{
  home.packages = with pkgs; [
    libsixel
  ];
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = rec {
      main = {
        shell = "${pkgs.zsh}/bin/zsh";
        dpi-aware = "yes";
        font = "monospace:size=8";
      };
      cursor.color = "${colors.background} ${colors.foreground}";
      colors = {
        alpha = 0.0;
        background = config.colorScheme.colors.base00;
        foreground = config.colorScheme.colors.base05;
        regular0 = config.colorScheme.colors.base00;
        regular1 = config.colorScheme.colors.base01;
        regular2 = config.colorScheme.colors.base02;
        regular3 = config.colorScheme.colors.base03;
        regular4 = config.colorScheme.colors.base04;
        regular5 = config.colorScheme.colors.base05;
        regular6 = config.colorScheme.colors.base06;
        regular7 = config.colorScheme.colors.base07;
        bright0 = config.colorScheme.colors.base08;
        bright1 = config.colorScheme.colors.base09;
        bright2 = config.colorScheme.colors.base0A;
        bright3 = config.colorScheme.colors.base0B;
        bright4 = config.colorScheme.colors.base0C;
        bright5 = config.colorScheme.colors.base0D;
        bright6 = config.colorScheme.colors.base0E;
        bright7 = config.colorScheme.colors.base0F;
      };
    };
  };
}
