_final: prev:
let
  inherit (prev) callPackage;
  inherit (prev) fetchFromGitHub;
  inherit (prev) fetchpatch;
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

  tpm2-pkcs11 = prev.tpm2-pkcs11.overrideAttrs (_: {
    configureFlags = [ "--with-fapi=no" ];
    patches = [
      (fetchpatch {
        url = "https://github.com/tpm2-software/tpm2-pkcs11/commit/7ad56b0faa30691e22a110b4ddc91251846d48a4.patch";
        hash = "sha256-ir12bFogdFtEF53G3eZjRXHNL5bfTVm9LODbRmBjvv4=";
      })
    ];
  });

  gnome-break-timer = callPackage ../pkgs/gnome-break-timer { };
  jmri = callPackage ../pkgs/jmri { };
  adguardian-term = callPackage ../pkgs/adguardian-term { };
}
