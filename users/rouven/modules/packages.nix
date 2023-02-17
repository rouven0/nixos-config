{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # temp here for testing
    thunderbird

    # essentials
    wpa_supplicant_gui
    pcmanfm
    xdg-utils
    snapper-gui

    # graphics
    evince
    gimp
    mpv
    yt-dlp
    ffmpeg

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
    #spotify # make probles atm
    virt-manager
    powerline-fonts
    ventoy-bin
    ripgrep
    baobab

    # libs
    libyubikey
    libfido2
  ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        image-viewers = [ "imv.desktop" "gimp.desktop" "swappy.desktop" "org.qutebrowser.qutebrowser.desktop" "google-chrome.desktop" ];
        browsers = [ "org.qutebrowser.qutebrowser.desktop" "google-chrome.desktop" ];
      in
      {
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "image/png" = image-viewers;
        "image/jpg" = image-viewers;
        "image/jpeg" = image-viewers;
        "image/tiff" = image-viewers;
        "image/gif" = image-viewers;
        "image/webp" = image-viewers;
        "image/ico" = image-viewers;
        "x-scheme-handler/http" = browsers;
        "x-scheme-handler/https" = browsers;
      };
  };
}

