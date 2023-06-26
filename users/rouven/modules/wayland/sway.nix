{ config, pkgs, lib, ... }:
{


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
}
