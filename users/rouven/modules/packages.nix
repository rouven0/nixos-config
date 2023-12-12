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
    pcmanfm
    xdg-utils # used for xdg-open
    appimage-run
    seafile-client

    # graphics
    zathura
    gimp
    krita
    ffmpeg
    drawio
    leafpad
    imv
    remmina

    # sound
    pavucontrol
    spotify

    # bluetooth
    blueman

    # internet
    google-chrome
    filezilla
    dbeaver

    # totp
    numberstation

    # messaging
    discord
    tdesktop
    element-desktop
    mattermost-desktop
    gajim

    # games
    prismlauncher
    superTuxKart

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
    # bitwarden

    # misc
    neofetch # obligatory
    virt-manager
    jetbrains.idea-ultimate #😎
    powerline-fonts
    croc # send files anywhere
    xournalpp
    rnote
    libreoffice
    mosh
    ansible

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

  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };

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
