{ config, pkgs, ... }:
{
  # control display backlight
  programs.light.enable = true;

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs;
      [
        nerdfonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        dejavu_fonts
        fira
      ];
  };
  console = {
    colors = let colors = config.home-manager.users.rouven.colorScheme.colors; in
      [
        colors.base00
        colors.base08
        colors.base0A
        colors.base0B
        colors.base0D
        colors.base0E
        colors.base0C
        colors.base05

        colors.base03
        colors.base08
        colors.base0A
        colors.base0B
        colors.base0D
        colors.base0E
        colors.base0C
        colors.base07
      ];
  };
  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
  ];
}
