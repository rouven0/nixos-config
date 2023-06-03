{ stdenv, lib, buildGoModule, path, pkgs, go, fetchFromGitHub, playerctl }:
buildGoModule rec {
  pname = "pww";
  version = "unstable-2023-04-06";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "pww";
    rev = "8c973e600052d1c94a0921ed10d0723c123187c6"; # unstable because 6.0.0 has some crashes
    hash = "sha256-IqLo1MlPGaM0n0TEhptiM5FvqJ8bsEPn7N2EEL6iWK8=";
  };

  buildInputs = [ playerctl ];

  outputs = [ "out" ];

  vendorSha256 = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  meta = with lib; {
    description = "Utility wrapper around playerctl";
    homepage = "https://github.com/Mic92/sops-nix";
    license = licenses.mit;
    maintainers = with maintainers; [ therealr5 ];
    platforms = platforms.all;
  };
}
