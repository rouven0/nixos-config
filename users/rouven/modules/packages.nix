{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # essentials
    (wpa_supplicant_gui.overrideAttrs (prev: {
      # better desktop application name. "wpa_gui" kinda sucks
      postInstall = prev.postInstall + ''

       substituteInPlace $out/share/applications/wpa_gui.desktop --replace "Name=wpa_gui" "Name=WPA Supplicant"
      '';
    })) # manage wifi
    cinnamon.nemo
    xdg-utils # used for xdg-open
    snapper-gui

    # graphics
    evince # pdf viewer
    gimp
    mpv # best video player out there
    ffmpeg

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
    prismlauncher # minecraft, but it actually works # not anymore lol
    superTuxKart

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
    bitwarden
    pass

    # misc
    neofetch # obligatory
    virt-manager
    jetbrains.idea-community
    powerline-fonts
    croc # send files anywhere

    # programming languages
    cargo
    rustc
    rustfmt
    gcc

    # libs
    libyubikey
    libfido2
    # (pkgs.texlive.combine {
    #   inherit (pkgs.texlive) scheme-medium;
    # })
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
