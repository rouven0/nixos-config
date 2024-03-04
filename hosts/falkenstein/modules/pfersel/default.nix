{ config, ... }:
{
  age.secrets.pfersel = {
    file = ../../../../secrets/falkenstein/pfersel.age;
  };
  services.pfersel = {
    enable = true;
    discord = {
      tokenFile = config.age.secrets.pfersel.path;
    };
  };
}
