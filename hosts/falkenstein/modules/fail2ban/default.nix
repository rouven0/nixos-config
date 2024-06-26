{ ... }:
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "141.30.0.0/16"
      "141.76.0.0/16"
    ];
    bantime = "10m";
    bantime-increment = {
      enable = true;
    };
    jails = {
      dovecot = ''
        enabled = true
        # aggressive mode add blocking for aborted connections
        filter = dovecot[mode=aggressive]
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

