{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "adguardian-term";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "lissy93";
    repo = pname;
    rev = version;
    hash = "sha256-r7dh31fZgcUBffzwoBqIoV9XhZOjJRb9aWZUuuiz7y8=";
  };
  cargoSha256 = "sha256-GB3CQ9VPBkKbT5Edq/jJlGEkVGICWSQloIt+nkHRDJU=";

  meta = with lib; {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance  Resources";
    homepage = "https://github.com/lissy93/adguardian-term";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealr5 ];
    mainProgram = "adguardian";
  };
}


