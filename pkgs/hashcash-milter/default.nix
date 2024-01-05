{ stdenv, fetchFromGitHub, lib, libmilter, db }:
stdenv.mkDerivation rec {
  pname = "hashcash-milter";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "zholos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yVpfvwpZUZQppZpmXmAqjoZH5shWUnA8aMVSOkPyQXw=";
  };
  buildInputs = [ libmilter db ];
  installPhase = ''
    mkdir -p $out/bin
    install -m 755 -p -s hashcash-milter $out/bin
  '';

  meta = with lib; {
    description = "Hashcash Milter";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ therealr5 ];
  };
}
