{ config, pkgs, ... }:
{
  imports = [
    ./hyprpaper.nix ./session.nix ./waybar.nix
  ];
  wayland.windowManager.hyprland.enable = true;
  home.sessionVariables = {
    GRIM_DEFAULT_DIR = "~/Pictures/Screenshots/";
  };
  home.packages = with pkgs; [
    pulseaudio # installed to have pactl
    jq
    libnotify
    wofi
    wl-clipboard
    grim
    slurp
    swappy
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;

    "wofi/config".text = ''
      allow_images = true
      term = alacritty
    '';

    "wofi/style.css".text = ''
      window {
        margin: 0px;
        border: 1px solid #${config.colorScheme.colors.base0D};
        background-color: #${config.colorScheme.colors.base00};
        border-radius: 15px;
      }
      #input {
        margin: 5px;
        border: none;
        color: #${config.colorScheme.colors.base05};
        background-color: #${config.colorScheme.colors.base02};
      }
      #inner-box,
      #outer-box {
        margin: 5px;
        border: none;
        background-color: #${config.colorScheme.colors.base00};
      }
      #text {
        margin: 5px;
        border: none;
        color: #${config.colorScheme.colors.base05};
      }
      #entry {
        background-color: #${config.colorScheme.colors.base00};
      }
      #entry:selected {
        background-color: #${config.colorScheme.colors.base03};
      }
    '';
    "swappy/config".text = ''
      [Default]
      save_dir = ~/Pictures/Screenshots/
      early_exit = true
    '';
    "mako/do-not-disturb.sh".text = ''
      if [[ $(makoctl mode) = 'default' ]];then
        notify-send 'Enabled Do Not Disturb mode'
        sleep 5
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
