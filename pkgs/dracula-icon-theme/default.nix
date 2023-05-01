{ lib, stdenv, fetchFromGitHub}:

let
  themeName = "Dracula";
  version = "2021-07-21";
in
stdenv.mkDerivation {
  pname = "dracula-icon-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "m4thewz";
    repo = "dracula-icons";
    rev = "2d3c83caa8664e93d956cfa67a0f21418b5cdad8";
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ therealr5 ];
  };
}
