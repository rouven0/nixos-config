{ lib, buildGoModule, libxcrypt, fetchFromGitHub, playerctl }:
buildGoModule rec {
  pname = "ssh3-server";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "francoismichel";
    repo = "ssh3";
    rev = "v${version}";
    hash = "sha256-0bd2hdvgapTGEGM7gdpVwxelN5BRbmdcgANbRHZ/nRw=";
  };

  subPackages = [ "cli/server" ];

  buildInputs = [ libxcrypt ];



  vendorHash = "sha256-ZtKxAKNyMnZ8v96GUUm4EukdIJD+ITDW9kHOez7nYmg=";
  postInstall = ''
    mv $out/bin/server $out/bin/ssh3-server
  '';

  meta = with lib; {
    description = "Faster and rich secure shell using HTTP/3";
    homepage = "https://github.com/francoismichel/ssh3";
    license = licenses.asl20;
    maintainers = with maintainers; [ therealr5 ];
    mainProgram = "ssh3";
    platforms = platforms.all;
  };
}
