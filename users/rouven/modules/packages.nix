{ pkgs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      dvisvgm dvipng# for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
    # (setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  });
in
{
  home.packages = with pkgs; [

    # essentials
    wpa_supplicant_gui
    pcmanfm
    xdg-utils # used for xdg-open
    tex
    appimage-run
    seafile-client

    # graphics
    evince # pdf viewer
    gimp
    krita
    ffmpeg
    drawio
    leafpad
    gamescope

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
    apache-directory-studio

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
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
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
    logseq
    xournalpp
    libreoffice

    # programming languages
    cargo
    rustc
    rustfmt
    clippy
    gcc
    nodejs_20

    # libs
    libyubikey
    libfido2
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.obs-studio.enable = true;
  programs.firefox.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        image-viewers = [ "imv.desktop" "gimp.desktop" "swappy.desktop" "org.qutebrowser.qutebrowser.desktop" "google-chrome.desktop" ];
        browsers = [ "google-chrome.desktop" "firefox.desktop" "org.qutebrowser.qutebrowser.desktop" ];
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
