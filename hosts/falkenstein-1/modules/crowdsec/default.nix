{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    crowdsec
    crowdsec-firewall-bouncer
    ipset
  ];
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "crowdsec";
        ensurePermissions = {
          "DATABASE crowdsec" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "crowdsec" ];

  };
  systemd.services.crowdsec = {
    after = [ "syslog.target" "network.target" "remote-fs.target" "nss-lookup.target" ];
    description = "Crowdsec agent";
    serviceConfig = {
      Type = "notify";
      ExecStartPre = "${pkgs.crowdsec}/bin/crowdsec -t -error";
      ExecStart = "${pkgs.crowdsec}/bin/crowdsec";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "always";
      RestartSec = 60;
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.crowdsec-firewall-bouncer = {
    path = [ pkgs.ipset pkgs.iptables ];
    after = [ "syslog.target" "network.target" "remote-fs.target" "nss-lookup.target" ];
    before = [ "netfilter-persistent.service" ];
    description = "Crowdsec firewall bouncer";
    serviceConfig = {
      # Type = "notify";
      ExecStartPre = "${lib.getExe pkgs.crowdsec-firewall-bouncer} -c /etc/crowdsec/crowdsec-firewall-bouncer.yaml -t";
      ExecStart = "${lib.getExe pkgs.crowdsec-firewall-bouncer} -c /etc/crowdsec/crowdsec-firewall-bouncer.yaml";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "always";
      RestartSec = 10;
      LimitNOFILE = 65536;
    };
    wantedBy = [ "multi-user.target" ];
  };


}
