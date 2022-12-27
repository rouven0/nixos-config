{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [ sops ];

  # directory party
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.generateKey = false;

}
