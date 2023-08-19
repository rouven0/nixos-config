{ pkgs, lib, ... }:
{
  systemd.user = {
    services.breaktimer = {
      Unit = {
        Description = "Simple notification to take a break";
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''${lib.getExe pkgs.libnotify} -i clock -e "It's time for a break" "Relax your eyes"'';
      };
    };
    timers.breaktimer = {
      Unit = {
        Description = "Timer for the break notification";
      };
      Timer = {
        OnCalendar = "*:0/20";
        Unit = "breaktimer.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };

    };
  };
}
