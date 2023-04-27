{ ... }:
{
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings.bind_port = 3000;
  };
}
