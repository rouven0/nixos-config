{ config, hyprpaper, ... }:
let 
  hyprpaper-pkg = hyprpaper.packages.x86_64-linux.default;
in
{
  home.packages = [
    hyprpaper-pkg
  ];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${../../../../images/wallpaper.png}
      wallpaper =eDP-1, ${../../../../images/wallpaper.png}
      wallpaper =HDMI-A-1, ${../../../../images/wallpaper.png}
  '';
  systemd.user.services.hyprpaper = {
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${hyprpaper-pkg}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Unit = {
      After = "graphical-session.target";
      Description = "Blazingly fast wayland wallpaper utility with IPC controls";
      Documentation = "https://github.com/hyprwm/hyprpaper";
      PartOf = "graphical-session.target";
    };
  };
}
