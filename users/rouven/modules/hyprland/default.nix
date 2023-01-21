{ config, pkgs, hyprpaper, ... }:
{
  imports = [ ./waybar.nix ];
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/hyprpaper.conf".text = ''
      preload = ${../../../../images/wallpaper.png}
      wallpaper =eDP-1, ${../../../../images/wallpaper.png}
      wallpaper =HDMI-A-1, ${../../../../images/wallpaper.png}
    '';
    "swaylock/config".text = ''
      indicator-radius=200
      indicator-thickness=3
      inside-color=00000000
      inside-ver-color=${config.colorScheme.colors.base0D}
      inside-clear-color=${config.colorScheme.colors.base0B}
      ring-color=${config.colorScheme.colors.base03}
      ring-wrong-color=${config.colorScheme.colors.base08}
      screenshot
      effect-blur=7x5
    '';
  };

  home.packages = with pkgs; [
    pulseaudio # installed to have pactl
    wofi
    wl-clipboard
    grim
    slurp
    font-awesome
    hyprpaper.packages.x86_64-linux.default
    swaylock-effects
  ];

  xdg.configFile."wofi/config".text = ''
    allow_images = true
    term = alacritty
  '';

  xdg.configFile."wofi/style.css".text = ''
    window {
      margin: 0px;
      border: 1px solid #${config.colorScheme.colors.base0D};
      background-color: #${config.colorScheme.colors.base00};
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

  programs.mako = {
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
    '';
  };
}
