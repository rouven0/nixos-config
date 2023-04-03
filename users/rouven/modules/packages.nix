{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # temp here for testing
    thunderbird

    # essentials
    wpa_supplicant_gui # manage wifi
    pcmanfm # rock solid file manager
    xdg-utils # used for xdg-open
    snapper-gui
    comma # run any command
    kleopatra
    python310Packages.pyhanko

    # graphics
    evince # pdf viewer
    gimp
    mpv # best video player out there
    yt-dlp # youtube downloader
    ffmpeg

    # sound
    pavucontrol
    (pkgs.callPackage ../../../pkgs/x32edit { })

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
    neofetch # obligatory
    virt-manager
    ventoy-bin

    trash-cli # better rm
    ripgrep # better grep
    exa # ls but with icons
    bat # better less
    duf # better df
    gnumake
    gdb

    powerline-fonts

    # libs
    libyubikey
    libfido2
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-medium;
    })
  ];

  programs.obs-studio.enable = true;
  programs.nix-index.enable = true;

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

