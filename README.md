# This Project moved to Sourcehut
https://git.sr.ht/~rouven/nixos-config


# Rouven's NixOS configuration files

![image](https://user-images.githubusercontent.com/72568063/213921069-670965f7-ad51-43ad-a211-63bb45a02648.png)

## Specs
- **Operating System:** [NixOS](https://nixos.org)
- **Window Manager:** [River](https://github.com/riverwm/river)
- **Overall Theme:** [Base16 Dracula](https://github.com/dracula/base16-dracula-scheme)
- **Shell:** [Zsh](https://www.zsh.org/)
- **Terminal:** [Foot](https://codeberg.org/dnkl/foot)
- **Editor:** [Helix](https://helix-editor.com)
- **Notifications:** [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- **Panel:** [Waybar](https://github.com/Alexays/Waybar)
- **File Manager:** [Yazi](https://yazi-rs.github.io/)

## Installation
Should work out of the box:\
Clone the repo, copy your hardware configuration to `./hosts/<hostname>/hardware-configuration.nix`, run `nixos-rebuild switch --flake .#<hostname>` and you are good to go.

## Currently configured machines (aka available hostnames)
### thinkpad
A ThinkPad L15 that I use for almost everything that one needs a monitor to.
#### Disk Layout
```
NAME             MOUNTPOINT  COMMENT
tmpfs            /           # root on tmpfs using impermanence
nvme0n1
├─nvme0n1p1      /boot
├─nvme0n1p2                  # LUKS-encrypted partition
│ └─luksroot                 # btrfs with subvolumes
│   ├─nix        /nix
│   ├─home       /home
│   ├─lib        /var/lib
│   └─log        /var/log
└─nvme0n1p3
  └─luksswap     [SWAP]      # encrypted swap partition
```

### nuc
Old Intel Nuc that I got from @LeBogoo. Running a few personal services.
#### Disk layout
```
NAME      MOUNTPOINT  COMMENT
tmpfs     /           # root on tmpfs
sda
├─sda1    /boot
├─sda2    [SWAP]
└─sda3                # btrfs
  ├─lib   /var/lib
  ├─log   /var/log
  └─nix   /nix
```

### falkenstein
Hetzner VPS running a few web apps.
#### Disk layout
```
NAME      MOUNTPOINT  COMMENT
sda
├─sda1    /
├─sda14               # BIOS boot
└─sda15   /boot/efi   # EFI stuff
```

### vm
Barebones configuration that can be easily deployed to virtual machines.

### iso
My custom installer and rescue image containing some personal tweaks.
