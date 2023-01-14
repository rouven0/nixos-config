{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # essentials
    wpa_supplicant_gui
    pcmanfm
    xsel
    lightlocker
    vlc

    # graphics
    feh
    okular
    gimp

    # sound
    pavucontrol

    # bluetooth
    blueman

    # internet
    google-chrome
    nextcloud-client
    qbittorrent

    # messaging
    discord
    tdesktop
    element-desktop
    whatsapp-for-linux

    # games
    prismlauncher # minecraft, but it actually works
    superTuxKart
    extremetuxracer

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-desktop
    #yubioath-flutter # do as soon as thing is done
    pass

    # misc
    neofetch
    trash-cli
    spotify
    nixpkgs-fmt
    virt-manager
    powerline-fonts
    ventoy-bin

    # libs
    libyubikey
    libfido2
  ];
}

