{ ... }:
{
  services.fail2ban = {
    enable = true;
    bantime = "10m";
    bantime-increment = {
      enable = true;
    };
    jails = {
      dovecot = ''
        enabled = true
        # aggressive mode add blocking for aborted connections
        filter = dovecot[mode=aggressive]
        bantime = 10m
        maxretry = 3
      '';
      postfix = ''
        enabled = true
        filter = postfix[mode=aggressive]
        maxretry = 3
      '';
    };
  };
}

