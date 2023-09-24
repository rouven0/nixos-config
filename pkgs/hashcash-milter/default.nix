{ stdenv, fetchFromGitHub, lib }:
stdenv.mkDerivation rec {
  pname = "hashcash-milter";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "zholos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yVpfvwpZUZQppZpmXmAqjoZH5shWUnA8aMVSOkPyQXw=";
  };

  meta = with lib; {
    description = "Hashcash Milter";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ therealr5 ];
  };
}
