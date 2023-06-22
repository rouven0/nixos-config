{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    swaylock-effects
    wl-clipboard
    swaynotificationcenter
    playerctl
    wdisplays
  ];

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = lib.getExe pkgs.swaylock-effects; }
      { event = "lock"; command = lib.getExe pkgs.swaylock-effects; }
    ];
    timeouts = [
      { timeout = 300; command = lib.getExe pkgs.swaylock-effects; }
    ];
  };
  systemd.user.services.swaync = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
      Restart = "on-failure";
    };
    Unit = {
      After = "graphical-session.target";
      Description = "Simple notification daemon with a GUI built for Sway";
      Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
      PartOf = "graphical-session.target";
    };
    environment.PATH = "${pkgs.coreutils}/bin";
  };

  xdg.configFile = {
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

    "wlogout/style.css".text = ''
      * {
        background-image: none;
      }
      window {
        background-color: rgba(12, 12, 12, 0);
      }
      button {
        color: #${config.colorScheme.colors.base05};
        background-color: #${config.colorScheme.colors.base00};
        border-style: solid;
        border-width: 2px;
        border-radius: 30px;
        margin: 5px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:active, button:hover {
      background-color: #${config.colorScheme.colors.base03};
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
