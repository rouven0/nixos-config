{ pkgs, lib, ... }:
{
  wayland.windowManager.river = {
    enable = true;
    systemd.extraCommands = [ "systemctl --user start river-session.target" ];
    settings = {
      focus-follows-cursor = "always";
      set-cursor-warp = "on-focus-change";
      attach-mode = "bottom";
      default-layout = "rivertile";
      output-layout = "rivertile";

      keyboard-layout = "-variant dvorak-alt-intl us";
      input."pointer-2-7-SynPS/2_Synaptics_TouchPad" = {
        tap = "enabled";
        drag = "enabled";
        middle-emulation = "enabled";
        accel-profile = "adaptive";
      };

      map.normal = lib.attrsets.zipAttrs [
        {
          "Super" = {
            Return = "spawn footclient";
            Space = "toggle-float";
            F = "toggle-fullscreen";
            H = "focus-output previous";
            J = "focus-view previous";
            K = "focus-view next";
            L = "focus-output next";
            O = "send-to-output next";
            S = "send-to-output next";
          };
          "Super+Shift" = {
            Return = "zoom";
            Q = "close";
            H = ''send-layout-cmd rivertile "main-ratio -0.05"'';
            J = ''send-layout-cmd rivertile "main-count -1"'';
            K = ''send-layout-cmd rivertile "main-count +1"'';
            L = ''send-layout-cmd rivertile "main-ratio +0.05"'';
          };
          "Alt" = builtins.mapAttrs (key: bind: "spawn " + bind) {
            Space = "${pkgs.fuzzel}/bin/fuzzel";
            A = "${pkgs.wofi-emoji}/bin/wofi-emoji";
          };
          "None" = builtins.mapAttrs (key: bind: "spawn \"" + bind + "\"") {
            Print = "${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
            XF86Launch2 = "${pkgs.sway-contrib.grimshot}/bin/grimshot save area - | ${pkgs.swappy}/bin/swappy -f -";
            XF86MonBrightnessUp = "${pkgs.light}/bin/light -A 10";
            XF86MonBrightnessDown = "${pkgs.light}/bin/light -U 10";
            XF86AudioMute = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            XF86AudioMicMute = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            XF86AudioRaiseVolume = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            XF86AudioLowerVolume = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            XF86Favorites = "${pkgs.systemd}/bin/loginctl lock-session";
            XF86Messenger = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel";
            Cancel = "${pkgs.swaynotificationcenter}/bin/swaync-client --hide-latest";
          };
          "Shift" = builtins.mapAttrs (key: bind: "spawn \"" + bind + "\"") {
            XF86AudioRaiseVolume = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
            XF86AudioLowerVolume = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
            Cancel = "${pkgs.swaynotificationcenter}/bin/swaync-client --cloes-all";
          };
        }
        # fuckery. Encodes https://github.com/riverwm/river/blob/c474be1537c833da35682ef54194c3d6ddf1eee0/example/init#L77 in nix
        (lib.attrsets.mapAttrs
          (mod: value: lib.attrsets.genAttrs (lib.lists.forEach (lib.lists.range 1 9) (num: toString num))
            (tag: value + builtins.replaceStrings [ "TAG" ] [ tag ] " $((1 << (TAG - 1)))"))
          {
            "Super" = "set-focused-tags";
            "Super+Shift" = "set-view-tags";
            "Super+Control" = "toggle-focused-tags";
            "Super+Shift+Control" = "toggle-view-tags";
          })
      ];
      map-pointer.normal = {
        "Super BTN_LEFT" = "move-view";
        "Super BTN_RIGHT" = "resize-view";
      };

      spawn = [
        "rivertile"
        ''"${pkgs.swaybg}/bin/swaybg -i ${../../../../images/wallpaper.png} -m fill"''
      ];
    };
  };
}
