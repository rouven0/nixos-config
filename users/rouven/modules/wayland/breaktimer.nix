{ pkgs, ... }:
{
  systemd.user.services.ianny = {
    Unit = {
      Description = "Ianny break timer";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.ianny}/bin/ianny";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
