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

    gh # github cli tool

    # sound
    pavucontrol

    # bluetooth
    blueman

    # internet
    google-chrome
    nextcloud-client

    # messaging
    discord
    tdesktop
    element-desktop
    whatsapp-for-linux

    # games
    minecraft
    superTuxKart
    extremetuxracer

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-desktop
    pass

    # misc
    neofetch
    trash-cli
    spotify
    nixpkgs-fmt
    virt-manager
    remmina
    powerline-fonts

    # libs
    libyubikey
    libfido2
  ];
}

