{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # essentials
    htop-vim
    lsof
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
    ffmpeg
    imv
    remmina

    # bluetooth
    blueman

    # internet
    google-chrome
    filezilla
    dbeaver

    # messaging
    tdesktop
    gajim
    gomuks
    fractal
    tuba # mastodon client

    # games
    prismlauncher
    superTuxKart

    # cryptography
    yubikey-manager
    python311Packages.pyhanko
    bitwarden-cli

    # misc
    neofetch # obligatory
    jetbrains.idea-ultimate #😎
    croc # send files anywhere
    xournalpp
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
    go

  ];


  programs.obs-studio.enable = true;
  # programs.firefox.enable = true;
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
