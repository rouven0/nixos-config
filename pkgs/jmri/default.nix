{ stdenv, fetchFromGitHub, lib, ant, jdk, ... }:
stdenv.mkDerivation rec {
  pname = "jmri";
  version = "5.3.5";

  src = fetchFromGitHub {
    owner = "jmri";
    repo = "jmri";
    rev = "v${version}";
    hash = "sha256-q3p9G16KhUjC3uUazNFDzAeKFIWu2BTds/Q1yhtSqPc=";
  };

  nativeBuildInputs = [
    ant
    jdk
  ];


  buildPhase = ''
    ant package-linux
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/Linux/JMRI/* $out
    # cp -r dist/Linux/JMRI/lib $out
    # mkdir -p $out/bin
    # cp dist/Linux/JMRI/PanelPro $out
    # cp dist/Linux/JMRI/SoundPro $out/bin
    # cp dist/Linux/JMRI/JmriFaceless $out/bin
    # mkdir -p $out/lib
    # cp -r dist/Linux/JMRI/lib/* $out/
  '';

  meta = with lib; {
    homepage = "https://jmri.org";
    description = "The Java Model Railroad Interface";
    license = licenses.gpl2;
    platforms = platforms.linux;
    # maintainers = with maintainers; [ therealr5 ];
  };
}
