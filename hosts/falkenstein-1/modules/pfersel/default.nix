{ ... }:
{
  # currently quite ugly and stateful. #todo nixify
  systemd.services.pfersel = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/root/Pfersel";
      ExecStart = "/root/Pfersel/venv/bin/python3 bot.py";
    };
  };
}
