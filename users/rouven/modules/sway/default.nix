{ config, pkgs, lib, ... }:

{
  imports = [
    # ./hyprpaper.nix
    ./session.nix
    ./waybar.nix
    ./shikane.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      startup = [
        {
          command = "${pkgs.swaybg}/bin/swaybg -i ${../../../../images/wallpaper.png}";
        }
        {
          command = "${pkgs.autotiling-rs}/bin/autotiling-rs";
        }
      ];
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
        "2:7:SynPS/2_Synaptics_TouchPad" = {
          tap = "enabled";
          drag = "enabled";
          middle_emulation = "enabled";
        };
      };
      keybindings =
        lib.mkOptionDefault {
          "Mod1+space" = "exec ${menu}";
          "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "XF86Launch2" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save area - | ${pkgs.swappy}/bin/swappy -f -";
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
          # audio controls
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";

          "XF86Favorites" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
          "XF86PowerOff" = "exec ${pkgs.wlogout}/bin/wlogout";

          "XF86Messenger" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel";
          "Cancel" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client --hide-latest";
          "Shift+Cancel" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client --cloes-all";
        };
    };
  };
  xdg.configFile = {
    "swaync".source = ./swaync;
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
  };
}
