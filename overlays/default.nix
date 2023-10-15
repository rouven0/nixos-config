_final: prev:
let
  inherit (prev) callPackage;
  inherit (prev) python3Packages;
  inherit (prev) fetchFromGitHub;
  inherit (prev) fetchPypi;
  inherit (prev) fetchpatch;
  inherit (prev) makeWrapper;
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

  # upstream package is broken and can't be fixed by overriding attrs. so I just completely redo it in here
  seahub = (python3Packages.buildPythonApplication
    rec {
      pname = "seahub";
      version = "11.0.1";
      format = "other";
      src = fetchFromGitHub {
        owner = "haiwen";
        repo = "seahub";
        rev = "v11.0.1-pro";
        sha256 = "sha256-dxMvbiAdECMZIf+HgA5P2gZYI9l+k+nhmdzfg90037A=";
      };


      dontBuild = true;

      doCheck = false; # disabled because it requires a ccnet environment

      nativeBuildInputs = [
        makeWrapper
      ];

      propagatedBuildInputs = with python3Packages; [
        django
        future
        django-compressor
        django-statici18n
        django-webpack-loader
        django-simple-captcha
        django-picklefield
        django-formtools
        mysqlclient
        pillow
        python-dateutil
        djangorestframework
        openpyxl
        requests
        requests-oauthlib
        chardet
        pyjwt
        pycryptodome
        qrcode
        pysearpc
        seaserv
        gunicorn
        markdown
        bleach
        python-ldap
        pyopenssl
        (buildPythonPackage rec {
          pname = "djangosaml2";
          version = "1.7.0";
          doCheck = false;
          propagatedBuildInputs = [
            pysaml2
            django
            defusedxml
          ];
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-WiMl2UvbOskLA5o5LXPrBF2VktlDnlBNdc42eZ62Fko=";
          };
        })
      ];

      installPhase = ''
        cp -dr --no-preserve='ownership' . $out/
        wrapProgram $out/manage.py \
          --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
      '';

      passthru = rec {
        python = prev.python3;
        pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
      };
    });

}
