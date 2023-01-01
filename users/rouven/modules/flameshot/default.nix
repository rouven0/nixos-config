{ config, ... }:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        contrastOpacity = 188;
        disabledTrayIcon=true;
      };
      Shortcuts = {
        TYPE_COPY = "Return";
      };
    };
  };
}
