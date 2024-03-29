{ config, pkgs, lib, ... }:

{
  imports = [
    ./river.nix
    ./breaktimer.nix
    ./waybar.nix
    ./shikane.nix
  ];

  home.packages = with pkgs; [
    swaylock-effects
    wl-clipboard
    swaynotificationcenter
    playerctl
    wdisplays
    wl-mirror
    wtype
    wofi
    jq
    (libinput.override { eventGUISupport = true; })
  ];

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = lib.getExe pkgs.swaylock-effects; }
      { event = "lock"; command = lib.getExe pkgs.swaylock-effects; }
    ];
    timeouts = [
      # { timeout = 300; command = lib.getExe pkgs.swaylock-effects; }
    ];
    systemdTarget = "graphical-session.target";
  };

  systemd.user.services.swayidle-inhibit = {
    Unit = {
      Description = "Service preventing swayidle from sleeping while any application is outputting or receiving audio";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.sway-audio-idle-inhibit}";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  systemd.user.services.swaync = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
      Restart = "on-failure";
    };
    Unit = {
      After = "graphical-session-pre.target";
      Description = "Simple notification daemon with a GUI built for Sway";
      Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
      PartOf = "graphical-session.target";
    };
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper tool for Wayland compositors";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${../../../../images/wallpaper.png} -m fill";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  services.wlsunset = {
    enable = true;
    longitude = "13";
    latitude = "51";
    temperature = {
      night = 4300;
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
      background=${config.colorScheme.palette.base00}ff
      text=${config.colorScheme.palette.base05}ff
      match=${config.colorScheme.palette.base08}ff
      selection=${config.colorScheme.palette.base02}ff
      selection-text=${config.colorScheme.palette.base04}ff
      border=${config.colorScheme.palette.base01}ff
    '';
    "swappy/config".text = ''
      [Default]
      save_dir = ~/Pictures/Screenshots/
      early_exit = true
    '';
    "swaylock/config".text = ''
      indicator-radius=200
      indicator-thickness=3
      inside-color=00000000
      inside-ver-color=${config.colorScheme.palette.base0D}
      inside-clear-color=${config.colorScheme.palette.base0B}
      ring-color=${config.colorScheme.palette.base03}
      ring-wrong-color=${config.colorScheme.palette.base08}
      screenshot
      effect-blur=7x5
    '';
    "wlogout/style.css".text = ''
      * {
        background-image: none;
      }
      window {
        background-color: rgba(12, 12, 12, 0);
      }
      button {
        color: #${config.colorScheme.palette.base05};
        background-color: #${config.colorScheme.palette.base00};
        border-style: solid;
        border-width: 2px;
        border-radius: 30px;
        margin: 5px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:active, button:hover {
      background-color: #${config.colorScheme.palette.base03};
        outline-style: none;
      }

      #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }

    '';
  };
}
