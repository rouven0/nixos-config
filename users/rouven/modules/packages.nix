{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # essentials
    wpa_supplicant_gui
    pcmanfm
    xdg-utils # used for xdg-open

    # graphics
    evince # pdf viewer
    gimp
    ffmpeg
    drawio

    # sound
    pavucontrol
    x32edit

    # bluetooth
    blueman

    # internet
    google-chrome

    # messaging
    discord
    tdesktop
    element-desktop
    gomuks # alternative matrix client

    # games
    # dwarf-fortress-packages.dwarf-fortress-full
    prismlauncher # minecraft, but it actually works # not anymore lol
    superTuxKart

    # yubikey and password stuff
    # yubikey-manager
    # yubikey-manager-qt
    # yubioath-flutter
    bitwarden
    pass

    # misc
    btop
    neofetch # obligatory
    virt-manager
    jetbrains.idea-ultimate #😎
    powerline-fonts
    croc # send files anywhere
    bacula
    hcloud
    jq

    # programming languages
    cargo
    rustc
    rustfmt
    clippy
    gcc

    # libs
    libyubikey
    libfido2
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.texlive.enable = true;
  programs.obs-studio.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        image-viewers = [ "imv.desktop" "gimp.desktop" "swappy.desktop" "org.qutebrowser.qutebrowser.desktop" "google-chrome.desktop" ];
        browsers = [ "google-chrome.desktop" "org.qutebrowser.qutebrowser.desktop" ];
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
