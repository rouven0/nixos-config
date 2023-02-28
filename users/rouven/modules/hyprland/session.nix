{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    swaylock-effects
    wlogout
  ];

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
      { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
    ];
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
    ];
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
