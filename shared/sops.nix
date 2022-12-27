{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ sops ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.generateKey = false;
  sops.defaultSopsFile = ../secrets/${config.networking.hostName}.yaml;
}
