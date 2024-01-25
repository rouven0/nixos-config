{ config, ... }:
let
  exportersConfig = config.services.prometheus.exporters;
in
{
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      # postgres.enable = true;
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString exportersConfig.node.port}" ];
          }
        ];
      }
      # {
      #   job_name = "postgres";
      #   static_configs = [
      #     {
      #       targets = [ "127.0.0.1:${toString exportersConfig.postgres.port}" ];
      #     }
      #   ];
      # }
    ];

  };
}
