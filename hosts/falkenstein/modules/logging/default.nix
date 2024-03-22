{ pkgs, ... }:
{
  services.rsyslogd = {
    enable = true;
    defaultConfig = ''
      :programname, isequal, "postfix" /var/log/postfix.log

      auth.*                          -/var/log/auth.log
    '';
  };
  services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
    weekly
    missingok
    notifempty
    rotate 4
    "/var/log/postfix.log" {
      compress
      delaycompress
      weekly
      rotate 156
      dateext
      dateformat .%Y-%m-%d
      extension log
    }
    "/var/log/nginx/*.log" {
      compress
      delaycompress
      weekly
      postrotate
        [ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`
      endscript
      rotate 26
      su nginx nginx
    }
  '';
}
