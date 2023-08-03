{ pkgs, ... }:
{
  home.packages = with pkgs; [
    river
  ];
  systemd.user.targets.river-session = {
    Unit = {
      After = "graphical-session-pre.target";
      BindsTo = "graphical-session.target";
      Description = "river compositor session";
      Wants = "graphical-session-pre.target";
    };
  };
  xdg.configFile = {
    "river/init" = {
      source =
        pkgs.writeShellScript "river-init.sh" ''
          riverctl focus-follows-cursor always
          riverctl attach-mode bottom
          riverctl spawn rivertile
          riverctl default-layout rivertile
          riverctl output-layout rivertile
          riverctl keyboard-layout -variant dvorak-alt-intl us
          riverctl input pointer-2-7-SynPS/2_Synaptics_TouchPad tap enabled
          riverctl input pointer-2-7-SynPS/2_Synaptics_TouchPad drag enabled
          riverctl input pointer-2-7-SynPS/2_Synaptics_TouchPad middle-emulation enabled
          
          riverctl spawn "${pkgs.swaybg}/bin/swaybg -i ${../../../../images/wallpaper.png}"

          riverctl map normal Super Return spawn footclient
          riverctl map normal Super+Shift Return zoom
          riverctl map normal Super+Shift Q close
          riverctl map normal Super F toggle-fullscreen

          riverctl map normal Super S send-to-output next

          riverctl map normal Super+Shift K send-layout-cmd rivertile "main-count +1"
          riverctl map normal Super+Shift J send-layout-cmd rivertile "main-count -1"
          riverctl map normal Super+Shift L send-layout-cmd rivertile "main-ratio +0.05"
          riverctl map normal Super+Shift H send-layout-cmd rivertile "main-ratio -0.05"

          riverctl map normal Super K focus-view next
          riverctl map normal Super J focus-view previous
          riverctl map normal Super L focus-output next
          riverctl map normal Super H focus-output previous
          riverctl map normal Super O send-to-output next
          riverctl map-pointer normal Super BTN_LEFT move-view

          riverctl map-pointer normal Super BTN_RIGHT resize-view

          riverctl map normal Alt Space spawn ${pkgs.fuzzel}/bin/fuzzel
          riverctl map normal Super Space toggle-float

          for i in $(seq 1 9)
          do
              tags=$((1 << ($i - 1)))
          
              # Super+[1-9] to focus tag [0-8]
              riverctl map normal Super $i set-focused-tags $tags
          
              # Super+Shift+[1-9] to tag focused view with tag [0-8]
              riverctl map normal Super+Shift $i set-view-tags $tags
          
              # Super+Control+[1-9] to toggle focus of tag [0-8]
              riverctl map normal Super+Control $i toggle-focused-tags $tags
          
              # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
              riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
          done

          riverctl map normal None Print spawn "${pkgs.sway-contrib.grimshot}/bin/grimshot copy area"
          riverctl map normal None XF86Launch2 spawn "${pkgs.sway-contrib.grimshot}/bin/grimshot save area - | ${pkgs.swappy}/bin/swappy -f -"
          riverctl map normal None XF86MonBrightnessUp spawn "${pkgs.light}/bin/light -A 10"
          riverctl map normal None XF86MonBrightnessDown spawn "${pkgs.light}/bin/light -U 10"
          riverctl map normal None XF86AudioMute spawn "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
          riverctl map normal None XF86AudioMicMute spawn "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"
          riverctl map normal None XF86AudioRaiseVolume spawn "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
          riverctl map normal None XF86AudioLowerVolume spawn "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
          riverctl map normal Shift XF86AudioRaiseVolume spawn "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%"
          riverctl map normal Shift XF86AudioLowerVolume spawn "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%"
          riverctl map normal None XF86Favorites spawn "${pkgs.systemd}/bin/loginctl lock-session"
          riverctl map normal None XF86Messenger spawn "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel"
          riverctl map normal None Cancel spawn "${pkgs.swaynotificationcenter}/bin/swaync-client --hide-latest"
          riverctl map normal Shift Cancel spawn "${pkgs.swaynotificationcenter}/bin/swaync-client --cloes-all"

          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL
          systemctl --user start river-session.target
        '';
    };
  };
}
