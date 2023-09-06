_final: prev:
let
  inherit (prev) callPackage;
  inherit (prev) fetchFromGitHub;
in
{
  wpa_supplicant_gui = prev.wpa_supplicant_gui.overrideAttrs
    (old: {
      # better desktop application name. "wpa_gui" kinda sucks
      postInstall = old.postInstall + ''

        substituteInPlace $out/share/applications/wpa_gui.desktop --replace "Name=wpa_gui" "Name=Manage Wifi"
      '';
    });

  pcmanfm = prev.pcmanfm.overrideAttrs (_: {
    # remove deskop preferences shortcut
    postInstall = ''
      rm $out/share/applications/pcmanfm-desktop-pref.desktop
    '';
  });

  wdisplays = prev.wdisplays.overrideAttrs (_: {
    # better desktop application name.
    postInstall = ''

       substituteInPlace $out/share/applications/network.cycles.wdisplays.desktop --replace "Name=wdisplays" "Name=Manage Displays"
      '';
  });

  pww = callPackage ../pkgs/pww { };
  crowdsec = prev.crowdsec.overrideAttrs (old: rec {
    version = "1.5.2";
    src = fetchFromGitHub {
      owner = "crowdsecurity";
      repo = old.pname;
      rev = "v${version}";
      hash = "sha256-260+XsRn3Mm/zCSvfEcBQ6j715KV4t1Z0CvXdriDzCs=";
    };
    # subPackages = [
    #   "cmd/crowdsec"
    #   "cmd/crowdsec-cli"
    #   "plugins/notifications/email/main.go"
    # ];

  });
  gnome-break-timer = callPackage ../pkgs/gnome-break-timer { };
  jmri = callPackage ../pkgs/jmri { };
  adguardian-term = callPackage ../pkgs/adguardian-term { };
  # some newer version
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "7118a0149cfa379dc8e83485aa78270121c112f2";
      hash = "sha256-VZFeNxu6wF1wWrLODpYmovQ9FZ2GY0ibgFdvca72ziI=";
    };
  });
}
