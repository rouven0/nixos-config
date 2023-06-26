{
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        {
          name = "external-monitor-default";
          output = [
            {
              match = "eDP-1";
              enable = true;
            }
            {
              match = "HDMI-A-1";
              enable = true;
              position = {
                x = 1920;
                y = 0;
              };
            }
          ];
        }
        {
          name = "builtin";
          output = [
            {
              match = "eDP-1";
              enable = true;
            }
          ];
        }
      ];
    };
  };
}
