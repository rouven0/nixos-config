{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
        ovmf.packages = [
          (pkgs.OVMF.override ({
            tpmSupport = true;
            secureBoot =
              true;
          })).fd
        ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  # allow libvirts internal network stuff
  networking.firewall.trustedInterfaces = [ "virbr0" "br0" ];
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    virt-viewer
  ];
}
