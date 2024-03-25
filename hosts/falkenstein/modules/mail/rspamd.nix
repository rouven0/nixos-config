{ config, pkgs, ... }:
{
  users.users.rspamd.extraGroups = [ "redis-rspamd" ];
  services = {
    rspamd = {
      enable = true;
      postfix.enable = true;
      locals = {
        "worker-controller.inc".text = ''
          password = "$2$g1jh7t5cxschj11set5wksd656ixd5ie$cgwrj53hfb87xndqbh5r3ow9qfi1ejii8dxok1ihbnhamccn1rxy";
        '';
        "redis.conf".text = ''
          read_servers = "/run/redis-rspamd/redis.sock";
          write_servers = "/run/redis-rspamd/redis.sock";
        '';
        "milter_headers.conf".text = ''
          use = ["x-spam-level", "x-spam-status", "x-spamd-result", "authentication-results" ];
        '';
        "dmarc.conf".text = ''
          reporting {
            enabled = true;
            email = 'reports@${config.networking.domain}';
            domain = '${config.networking.domain}';
            org_name = '${config.networking.domain}';
            from_name = 'DMARC Aggregate Report';
          }
        '';
        "dkim_signing.conf".text = ''
          selector = "rspamd";
          allow_username_mismatch = true;
          path = /var/lib/rspamd/dkim/$domain.key;
        '';
      };
    };
    redis = {
      vmOverCommit = true;
      servers.rspamd = {
        enable = true;
      };
    };
    nginx.virtualHosts."rspamd.${config.networking.domain}" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:11334";
          proxyWebsockets = true;
        };
      };
    };
  };
  systemd = {
    services.rspamd-dmarc-report = {
      description = "rspamd dmarc reporter";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.rspamd}/bin/rspamadm dmarc_report -v";
        User = "rspamd";
        Group = "rspamd";
      };
      startAt = "daily";
    };
  };
}

