{ config, ... }:
{
  age.secrets.pfersel = {
    file = ../../../../secrets/falkenstein/pfersel.age;
    owner = "pfersel";
  };
  services.pfersel = {
    enable = true;
    discord = {
      tokenFile = config.age.secrets.pfersel.path;
    };
  };
}
