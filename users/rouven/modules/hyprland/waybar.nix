{ config, pkgs, hyprland, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = hyprland.packages.x86_64-linux.waybar-hyprland;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        modules-left = [ "wlr/workspaces" ];
        modules-right = [ "network" "cpu" "temperature" "pulseaudio" "battery" "tray" "clock" ];
        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = "󰈀 {ifname} via {gwaddr}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        cpu = {
          format = "{usage}% ";
        };
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" ];
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source} ";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "";
            headset = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% ";
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
    
    #clock,
    #battery,
    #cpu,
    #memory,
    #temperature,
    #network,
    #pulseaudio,
    #tray{
        border-radius: 30px; 
        padding: 0 10px;
        color: #${config.colorScheme.colors.base05};
    }
    
    #window,
    #workspaces {
        margin: 0 4px;
    }
    
    #clock {
        background-color: #${config.colorScheme.colors.base00};
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
    
    #tray {
        background-color: #${config.colorScheme.colors.base01};
        color: #${config.colorScheme.colors.base05};
    }

  '';
}
