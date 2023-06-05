{ config, pkgs, ... }:

{
  imports = [
    # ./hyprpaper.nix
    ./session.nix
    ./waybar.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = {

      modifier = "Mod4";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      terminal = "${pkgs.foot}/bin/footclient";
      bars = [ ];
      gaps = {
        outer = 5;
        inner = 12;
      };
      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "dvorak-alt-intl";
        };
      };
    };
  };
  xdg.configFile = {
    "fuzzel/fuzzel.ini".text = ''
      [main]
      icon-theme=${config.gtk.iconTheme.name}
      show-actions=yes
      width=80
      terminal=${pkgs.foot}/bin/foot

      [colors]
      background=${config.colorScheme.colors.base00}ff
      text=${config.colorScheme.colors.base05}ff
      match=${config.colorScheme.colors.base08}ff
      selection=${config.colorScheme.colors.base02}ff
      selection-text=${config.colorScheme.colors.base04}ff
      border=${config.colorScheme.colors.base01}ff
    '';
  };
}
