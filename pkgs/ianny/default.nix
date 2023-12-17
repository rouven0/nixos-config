{ rustPlatform, fetchFromGitHub, lib, ninja, dbus, pkg-config, gettext }:
rustPlatform.buildRustPackage rec {
  pname = "ianny";
  version = "unstable-2023-12-16";
  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = pname;
    rev = "370bea372c35610e65426f5a1c45db99584dfb9a";
    hash = "sha256-oWwRCQSP0g6IJh3cEgD32AIBF/pfN9QGJ9LANjCthMw=";
  };
  cargoSha256 = "sha256-5/Sb2ds+xfcYFqTF3RObPScDzK4FdBNk8T1Z5YcQgCM=";
  buildInputs = [
    dbus
    ninja
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Wayland break timer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ therealr5 ];
  };
}
