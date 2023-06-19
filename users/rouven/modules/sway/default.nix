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
          command = "${lib.getExe pkgs.swaybg} -i ${../../../../images/wallpaper.png}";
        }
        {
          command = lib.getExe pkgs.autotiling-rs;
        }
      ];
      modifier = "Mod4";
      menu = lib.getExe pkgs.fuzzel;
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
          "Print" = "exec ${lib.getExe pkgs.sway-contrib.grimshot} copy area";
          "XF86Launch2" = "exec ${lib.getExe pkgs.sway-contrib.grimshot} save area - | ${lib.getExe pkgs.swappy} -f -";
          "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.light} -A 10";
          "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.light} -U 10";
          # audio controls
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";

          "XF86Favorites" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
          "XF86PowerOff" = "exec ${lib.getExe pkgs.wlogout}";

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
      terminal=${lib.getExe pkgs.foot}

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
