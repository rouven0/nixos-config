{ lib
, stdenv
, fetchurl
, meson
, vala
, pkg-config
, cairo
, gsound
, gtk3
, json-glib
, libcanberra
, libnotify
, ninja
, gtk4
, glib
, gsettings-desktop-schemas
, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  pname = "gnome-break-timer";
  version = "2.1.0";
  src = fetchurl {
    url = "https://gitlab.gnome.org/GNOME/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-B13vZbYwniB9+ZF/XduJHvOd6FwZUpMIdbB8EPUbuS8=";
  };

  MESON_INSTALL_PREFIX = "$out";
  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    cairo
    gsound
    gtk3
    json-glib
    libcanberra
    libnotify
    wrapGAppsHook
    glib.dev
  ];
  buildInputs = [
    gtk4
    glib
    gsettings-desktop-schemas
  ];

  patches = [ ./0001-remove-install-script.patch ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/BreakTimer";
    description = "Clock application designed for GNOME 3";
    maintainers = [ maintainers.therealr5 ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}

