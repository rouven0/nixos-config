{ lib, ... }:
{
  services.fail2ban = {
    enable = true;
    bantime = "10m";
    bantime-increment = {
      enable = true;
    };
    jails = {
      sshd = lib.mkForce ''
        enabled = true
        port = ssh
        filter= sshd[mode=aggressive]
      '';
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

