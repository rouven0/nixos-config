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

    # editing
    fzf
    powerline-fonts

    gh # github cli tool

    # sound
    pavucontrol

    # bluetooth
    blueman

    # internet
    thunderbird # TODO configure
    discord
    google-chrome
    nextcloud-client

    # messaging
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
    fzf
    neofetch
    trash-cli
    spotify
    nixpkgs-fmt
    virt-manager
    remmina

    # libs
    libyubikey
    libfido2
  ];
}

