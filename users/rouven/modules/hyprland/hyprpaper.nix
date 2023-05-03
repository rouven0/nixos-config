{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpaper
  ];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${../../../../images/wallpaper.png}
    wallpaper =eDP-1, ${../../../../images/wallpaper.png}
    wallpaper =HDMI-A-1, ${../../../../images/wallpaper.png}
  '';
  systemd.user.services.hyprpaper = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
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
