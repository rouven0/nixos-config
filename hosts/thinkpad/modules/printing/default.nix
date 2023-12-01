{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    stateless = true;
    browsedConf = ''
      BrowsePoll cups.agdsn.network
      LocalQueueNamingRemoteCUPS RemoteName
    '';
    drivers = with pkgs; [ cups-kyocera ];
  };
}
