{ config, lib, pkgs, ... }:
# Virtualisation with gpu passthrough
# Following https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# let
#   gpuHook = pkgs.writeShellScript "gpuhook.sh" ''
#     export PATH=$PATH:${lib.makeBinPath [pkgs.pciutils pkgs.kmod pkgs.psmisc pkgs.systemd pkgs.coreutils]}
#     gpu_domains=(
#         win11
#     )
#     function gpu_begin {
#         set -x
#         device=$(lspci -nnD | grep "VGA compatible controller" | grep Intel)
#         # Stop display manager
#         systemctl stop greetd.service
#         # Unbind vtconsole
#         for i in /sys/class/vtconsole/*/bind; do
#             echo 0 > "$i"
#         done
#         # Kill pulseaudio
#         killall pipewire
#         killall pipewire-pulse
#         # Unbind GPU
#         echo "$device" | cut -d' ' -f1 > /sys/module/i915/drivers/pci:i915/unbind
#         # Unload modules
#         rmmod snd_hda_intel
#         rmmod i915
#         # Load vfio
#         modprobe vfio-pci ids="$(echo "$device" | grep -o 8086:....)"
#     }
#     function gpu_end {
#         set -x
#         # Unload vfio
#         rmmod vfio_pci
#         # Load modules
#         modprobe snd_hda_intel
#         modprobe i915
#         # Rebind vtconsole
#         for i in /sys/class/vtconsole/*/bind; do
#             echo 1 > "$i"
#         done
#         # Start display manager
#         systemctl start greetd.service
#     }
#     # Run only for gpu_domains
#     for d in "''${gpu_domains[@]}"; do
#         [ "$d" = "$1" ] && gpu_domain=true
#     done
#     if [ "$gpu_domain" = true ]; then
#         [ "$2" = prepare ] && [ "$3" = begin ] && gpu_begin
#         [ "$2" = release ] && [ "$3" = end ] && gpu_end
#     fi
#     true
#   '';
# in
{

  boot.kernelParams = [ "intel_iommu=on" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # fix to enable secure boot in vms
  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
      mode = "0644";
      user = "libvirtd";
    };

  };
  environment.systemPackages = with pkgs; [
    virt-viewer
  ];
  # systemd.services.libvirtd.preStart =
  #   ''
  #     mkdir -p /var/lib/libvirt/hooks
  #     chmod 755 /var/lib/libvirt/hooks

  #     # Copy hook files
  #     cp -f ${gpuHook} /var/lib/libvirt/hooks/qemu

  #     # Make them executable
  #     chmod +x /var/lib/libvirt/hooks/qemu
  #   '';

}
