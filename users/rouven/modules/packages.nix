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
    (zathura.override { plugins = [ zathuraPkgs.zathura_pdf_mupdf ]; })
    gimp
    ffmpeg
    imv

    # bluetooth
    blueman

    # internet
    google-chrome

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
    # python311Packages.pyhanko # broken, TODO fix
    bitwarden-cli

    # misc
    neofetch # obligatory
    jetbrains.idea-ultimate #😎
    croc # send files anywhere
    xournalpp
    libreoffice
    mosh
    typst
    typst-preview

    # programming languages
    cargo
    rustc
    rustfmt
    clippy
    gcc
    nodejs_20
    gnumake
    go

    # fancy tools
    just
    (himalaya.override { buildFeatures = [ "pgp-commands" ]; })
    # strace but with colors
    (strace.overrideAttrs (_: {
      patches = [
        (fetchpatch {
          url = "https://raw.githubusercontent.com/xfgusta/strace-with-colors/main/strace-with-colors.patch";
          hash = "sha256-gcQldGsRgvGnrDX0zqcLTpEpchNEbCUFdKyii0wetEI=";
        })
      ];
    }))

  ];


  programs.obs-studio.enable = true;
  programs.firefox.enable = true;
  programs = {
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          withExternalGnupg = true;
          isDefault = true;
          settings = {
            "intl.date_time.pattern_override.connector_short" = "{1} {0}";
            "intl.date_time.pattern_override.date_short" = "yyyy-MM-dd";
            "intl.date_time.pattern_override.time_short" = "HH:mm";
          };
        };
      };
    };
  };
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
