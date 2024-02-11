_final: prev:
let
  inherit (prev) callPackage;
  inherit (prev) fetchFromGitHub;
  inherit (prev) fetchPypi;
  inherit (prev) fetchpatch;
  inherit (prev) makeWrapper;
in
rec {
  pcmanfm = prev.pcmanfm.overrideAttrs (_: {
    # remove deskop preferences shortcut
    postInstall = ''
      rm $out/share/applications/pcmanfm-desktop-pref.desktop
    '';
  });

  pww = callPackage ../pkgs/pww { };
  ianny = callPackage ../pkgs/ianny { };

  python3 = prev.python3.override {
    packageOverrides = _finel: prev: {
      tpm2-pytss = prev.tpm2-pytss.overrideAttrs (old: {
        # https://github.com/NixOS/nixpkgs/pull/287804/
        patches = old.patches ++ [
          (fetchpatch {
            name = "fix-newer-cryptography-42-0-1-support.patch";
            url = "https://github.com/tpm2-software/tpm2-pytss/commit/0fbb9d099370c0a7031dd13990986538f586836a.patch";
            sha256 = "sha256-xnQIr4/iJra0+rn5estVqSvG8pXcuwWykmmayBpCzgw=";
          })

        ];
      });
    };

  };
  python3Packages = python3.pkgs;
  tpm2-pkcs11 = prev.tpm2-pkcs11.override { fapiSupport = false; };

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
