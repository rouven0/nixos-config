{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # essentials
    wpa_supplicant_gui
    pcmanfm
    xsel
    vlc

    # graphics
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
    yubioath-flutter
    pass

    # misc
    neofetch
    trash-cli
    spotify
    virt-manager
    powerline-fonts
    ventoy-bin

    # libs
    libyubikey
    libfido2
  ];
}

