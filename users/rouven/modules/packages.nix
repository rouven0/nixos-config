{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # essentials
    wpa_supplicant_gui
    pcmanfm
    xsel

    # graphics
    evince
    gimp
    mpv

    # sound
    pavucontrol

    # bluetooth
    blueman

    # internet
    google-chrome
    nextcloud-client
    transmission-gtk

    # messaging
    discord
    tdesktop
    element-desktop

    # games
    prismlauncher # minecraft, but it actually works
    superTuxKart

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
    bitwarden
    bitwarden-cli

    # misc
    neofetch
    trash-cli
    spotify
    virt-manager
    powerline-fonts
    ventoy-bin
    ripgrep

    # libs
    libyubikey
    libfido2
  ];
}

