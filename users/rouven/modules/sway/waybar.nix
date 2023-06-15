{ self, config, pkgs, ... }:
{
  systemd.user.services.waybar.Service.Environment = "PATH=${pkgs.swaynotificationcenter}/bin";
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # package = hyprland.packages.x86_64-linux.waybar-hyprland;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        # modules-left = [ "wlr/workspaces" "custom/spotifytitle" "hyprland/window" ];
        modules-left = [ "sway/workspaces" "custom/spotifytitle" "sway/window" ];
        modules-right = [ "network" "cpu" "temperature" "pulseaudio" "battery" "tray" "custom/notification" "clock" ];
        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = "󰈀 {ifname} via {gwaddr}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        "sway/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };
        "sway/window" = {
          format = "   {}";
          # separate-outputs = true;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon} ";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          # exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/spotifytitle" = {
          format = "  {}";
          max-length = 80;
          return-type = "json";
          exec = "${self.packages.x86_64-linux.pww}/bin/pww -w spotifyd:title -p None 2> /dev/null";
        };
        cpu = {
          format = "{usage}% ";
        };
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" ];
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source} ";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = " {volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "";
            headset = "󰋎";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% 󱊦";
          format-plugged = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
        };
        tray = {
          spacing = 10;
        };
      };
    };
  };

  xdg.configFile."waybar/style.css".text = ''
    * {
        font-family: Roboto, Helvetica, Arial, sans-serif, Iosevka Nerd Font;
        font-size: 13px;
    }
    
    window#waybar {
        background-color: transparent;
        color: #${config.colorScheme.colors.base05};
        transition-property: background-color;
        transition-duration: .5s;
    }
    
    window#waybar.hidden {
      background-color: transparent;
    }

    #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #${config.colorScheme.colors.base05};
    }
    
    #workspaces button.active {
        background-color: #${config.colorScheme.colors.base04};
        box-shadow: inset 0 -3px #${config.colorScheme.colors.base05};
    }
    
    #workspaces button.urgent {
        background-color: #eb4d4b;
    }
    
    #custom-spotifytitle,
    #custom-notification,
    #clock,
    #battery,
    #cpu,
    #memory,
    #temperature,
    #network,
    #pulseaudio,
    #window,
    #tray{
        border-radius: 30px; 
        padding: 0 10px;
        color: #${config.colorScheme.colors.base05};
    }
    
    #window,
    #workspaces {
        margin: 0 4px;
    }

    #window {
        background-color: #${config.colorScheme.colors.base00};
    }

    
    #clock {
        background-color: #${config.colorScheme.colors.base00};
    }
    
    #custom-spotifytitle {
        background: #1db954;
        color: #191414;
        opacity: 1;
        transition-property: opacity;
        transition-duration: 0.25s;
    }
    
    #custom-spotifytitle.Paused,
    #custom-spotifytitle.Inactive {
        opacity: 0.5;
    }

    #battery {
        background-color: #${config.colorScheme.colors.base02};
        color: #${config.colorScheme.colors.base05};
    }
    
    #battery.charging, #battery.plugged {
        color: #${config.colorScheme.colors.base05};
        background-color: #${config.colorScheme.colors.base02};
    }
    
    #battery.critical:not(.charging) {
        background-color: #${config.colorScheme.colors.base08};
        color: #${config.colorScheme.colors.base01};
    }
    
    #cpu {
        background-color: #${config.colorScheme.colors.base06};
        color: #${config.colorScheme.colors.base01};
    }
    
    #network {
        background-color: #${config.colorScheme.colors.base07};
        color: #${config.colorScheme.colors.base01};
    }
    
    #network.disconnected {
        background-color: #${config.colorScheme.colors.base08};
    }
    
    #pulseaudio {
        background-color: #${config.colorScheme.colors.base03};
        color: #${config.colorScheme.colors.base05};
    }
    
    #temperature {
        background-color: #${config.colorScheme.colors.base05};
        color: #${config.colorScheme.colors.base01};
    }
    
    #temperature.critical {
        background-color: #${config.colorScheme.colors.base08};
        color: #${config.colorScheme.colors.base01};
    }
    
    #custom-notification,
    #tray {
        background-color: #${config.colorScheme.colors.base01};
        color: #${config.colorScheme.colors.base05};
    }

  '';
}