{
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        {
          # TODO home vertical
          name = "home";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 1920;
                y = 0;
              };
            }
            {
              match = "DP-2";
              enable = true;
              position = {
                x = 0;
                y = 0;
              };
            }
            {
              match = "HDMI-A-1";
              enable = true;
              position = {
                x = 3840;
                y = 0;
              };
            }
          ];
        }
        {
          name = "external-monitor-default";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 0;
                y = 0;
              };
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
          name = "external-monitor-usb-c";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 1920;
                y = 0;
              };
            }
            {
              match = "DP-2";
              enable = true;
              position = {
                x = 0;
                y = 0;
              };
            }
          ];
        }
        # vertical mode if on dp-3
        {
          name = "external-monitor-usb-c-vertical";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 1080;
                y = 840;
              };
            }
            {
              match = "DP-3";
              enable = true;
              position = {
                x = 0;
                y = 0;
              };
              transform = "270";
            }
          ];
        }
        {
          name = "builtin";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 0;
                y = 0;
              };
            }
          ];
        }
      ];
    };
  };
}
