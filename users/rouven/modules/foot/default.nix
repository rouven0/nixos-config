{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    libsixel
  ];

  # enable socket activation
  systemd.user = {
    services.foot = {
      Unit = {
        Requires = "foot.socket";
      };
    };
    sockets.foot = {
      Socket = {
        ListenStream = "%t/foot.sock";
      };
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    package = pkgs.foot.overrideAttrs (old: {
      # don't install systemd units
      mesonFlags = old.mesonFlags ++ [
        "-Dsystemd-units-dir=''"
      ];
    });

    settings = rec {
      main = {
        shell = "${pkgs.zsh}/bin/zsh";
        # dpi-aware = "yes";
        font = "monospace:family=Iosevka Nerd Font:size=12";
        notify = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
      };
      cursor.color = "${colors.background} ${colors.foreground}";
      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      };
      bell = {
        urgent = true;
        notify = true;
      };
      colors =
        let
          colors = config.colorScheme.palette;
        in
        {
          # alpha = if (config.colorScheme.kind == "dark") then 0.0 else 1.0;
          background = colors.base00;
          foreground = colors.base05;
          regular0 = colors.base02;
          regular1 = colors.base08;
          regular2 = colors.base0A;
          regular3 = colors.base0B;
          regular4 = colors.base0D;
          regular5 = colors.base0E;
          regular6 = colors.base0C;
          regular7 = colors.base05;
          bright0 = colors.base03;
          bright1 = colors.base08;
          bright2 = colors.base0A;
          bright3 = colors.base0B;
          bright4 = colors.base0D;
          bright5 = colors.base0E;
          bright6 = colors.base0C;
          bright7 = colors.base07;
        };
    };
  };
}
