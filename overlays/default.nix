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
  crowdsec-firewall-bouncer = callPackage ../pkgs/crowdsec-firewall-bouncer { };
  gnome-break-timer = callPackage ../pkgs/gnome-break-timer { };
  jmri = callPackage ../pkgs/jmri { };
  adguardian-term = callPackage ../pkgs/adguardian-term { };
}
