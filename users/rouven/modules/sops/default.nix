{ config, ... }:
{
  sops = {
    age.sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
    age.generateKey = false;
    defaultSopsFile = ../../../../secrets/${config.home.username}.yaml;
  };
}
