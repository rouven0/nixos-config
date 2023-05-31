{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "adguardian-term";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lissy93";
    repo = pname;
    rev = version;
    hash = "sha256-UZIwVvBBBj82IxGuZPKaNc/UZI1DAh5/5ni3fjiRF4o=";
  };
  cargoSha256 = "sha256-5JBX7zCKlaMj2+/YudQLapb3WzDEH7l3pqgN8/M2IEs=";

  meta = with lib; {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance  Resources";
    homepage = "https://github.com/lissy93/adguardian-term";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealr5 ];
  };
}


