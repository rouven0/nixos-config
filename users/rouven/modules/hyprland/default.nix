{ config, pkgs, ... }:
{
  imports = [
    ./hyprpaper.nix
    ./session.nix
    ./waybar.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf; # todo nix config when available
  };

  home.sessionVariables = {
    GRIM_DEFAULT_DIR = "~/Pictures/Screenshots/";
  };
  home.packages = with pkgs; [
    pulseaudio # installed to have pactl
    jq
    libnotify
    fuzzel
    wl-clipboard
    grim
    slurp
    swappy
  ];

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

    "swappy/config".text = ''
      [Default]
      save_dir = ~/Pictures/Screenshots/
      early_exit = true
    '';
    "mako/do-not-disturb.sh".text = ''
      if [[ $(makoctl mode) = 'default' ]];then
        notify-send 'Enabled Do Not Disturb mode'
        sleep 3
        makoctl mode -s do-not-disturb
      else
        makoctl mode -s default
        notify-send 'Disabled Do Not Disturb mode'
      fi
    '';
  };

  services.mako = {
    enable = true;
    backgroundColor = "#${config.colorScheme.colors.base02}FF";
    borderRadius = 20;
    textColor = "#${config.colorScheme.colors.base05}FF";
    layer = "overlay";
    defaultTimeout = 10000;
    extraConfig = ''
      [urgency=high]
      background-color=#${config.colorScheme.colors.base08}
      default-timeout=0
      [mode=do-not-disturb]
      invisible=1
    '';
  };
}
