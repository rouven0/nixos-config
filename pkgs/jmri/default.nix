{ stdenv, fetchFromGitHub, lib, ant, jdk11, ... }:
stdenv.mkDerivation rec {
  pname = "jmri";
  version = "5.6";

  src = fetchFromGitHub {
    owner = "jmri";
    repo = "jmri";
    rev = "v${version}";
    hash = "sha256-0FUdvwijRqYAlT6YgB+KzAMdZ6uZ/RGySFUp494Eob8=";
  };

  nativeBuildInputs = [
    ant
    jdk11
  ];

  buildInputs = [
    jdk11
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
    maintainers = with maintainers; [ therealr5 ];
  };
}
