{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # essentials
    networkmanagerapplet
    pcmanfm
    xsel
    lightlocker
    vlc

    # graphics
    lxappearance
    feh
    flameshot
    picom
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
    thunderbird
    discord
    google-chrome
    nextcloud-client
    zoom-us

    # messaging
    tdesktop
    element-desktop
    whatsapp-for-linux

    # games
    minecraft
    superTuxKart
    extremetuxracer
    wine

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

