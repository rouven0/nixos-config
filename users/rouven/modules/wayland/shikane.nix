{
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        {
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
          name = "home-vertical";
          output = [
            {
              match = "eDP-1";
              enable = true;
              position = {
                x = 1080;
                y = 0;
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
            {
              match = "HDMI-A-1";
              enable = true;
              position = {
                x = 3000;
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
                x = 0;
                y = 1440;
              };
            }
            {
              match = "/P24h/";
              enable = true;
              mode = {
                height = 1440;
                width = 2560;
                refresh = 60;
              };
              position = {
                x = 0;
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
