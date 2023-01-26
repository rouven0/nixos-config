{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

let
  themeName = "Dracula";
  version = "1.0";
in
stdenv.mkDerivation {
  pname = "dracula-icon-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "m4thewz";
    repo = "dracula-icons";
    rev = "main";
    sha256 = "GY+XxTM22jyNq8kaB81zNfHRhfXujArFcyzDa8kjxCQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/${themeName}
    cp -a * $out/share/icons/${themeName}/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = platforms.all;
    maintainers = with maintainers; [ therealr5 ];
  };
}
