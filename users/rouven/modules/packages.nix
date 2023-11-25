{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # essentials
    htop-vim
    lsof
    killall
    zip
    unzip
    man-pages
    wpa_supplicant_gui
    pcmanfm
    xdg-utils # used for xdg-open
    appimage-run
    seafile-client

    # printing
    cups

    # graphics
    zathura
    gimp
    krita
    ffmpeg
    drawio
    leafpad
    imv

    # sound
    pavucontrol
    x32edit
    spotify

    # bluetooth
    blueman

    # internet
    google-chrome
    filezilla
    dbeaver

    # messaging
    discord
    tdesktop
    element-desktop
    mattermost-desktop
    gajim

    # games
    prismlauncher # minecraft, but it actually works # not anymore lol
    superTuxKart

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
    bitwarden

    # misc
    neofetch # obligatory
    virt-manager
    jetbrains.idea-ultimate #😎
    powerline-fonts
    croc # send files anywhere
    xournalpp
    libreoffice
    mosh

    # programming languages
    cargo
    rustc
    rustfmt
    clippy
    gcc
    nodejs_20
    gnumake

    plantuml

    # libs
    libyubikey
    libfido2
    python311Packages.pyhanko
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.obs-studio.enable = true;
  programs.firefox.enable = true;
  services.gnome-keyring.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        image-viewers = [ "imv.desktop" "gimp.desktop" "swappy.desktop" "org.qutebrowser.qutebrowser.desktop" "google-chrome.desktop" ];
        browsers = [ "google-chrome.desktop" "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
      in
      {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
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
