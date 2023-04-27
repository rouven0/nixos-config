{ ... }:
{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings.bind_port = 3000;
  };
}
