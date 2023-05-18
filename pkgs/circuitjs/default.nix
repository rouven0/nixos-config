{ stdenv, fetchurl, makeWrapper, wrapGAppsHook, lib, libX11, libXext, gtk3-x11, dbus, nspr, alsa-lib, glib, expat, gdk-pixbuf, mesa, xorg, nss, cups, ffmpeg, cairo, pango, at-spi2-atk, atk, at-spi2-core, libdrm, ... }:
stdenv.mkDerivation rec {
  pname = "circuitjs";
  version = "2.8.0";

  src = fetchurl {
    url = "https://www.falstad.com/circuit/offline/circuitjs1-linux64.tgz";
    hash = "sha256-dyIEuDA7FRwHCok41wcJAr8eqksJSOdChafPPh0Q3zM=";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  libPath = lib.makeLibraryPath [
    libX11
    libXext
    alsa-lib
    xorg.libXi
    xorg.libXrender
    xorg.libXfixes
    xorg.libXtst
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXdamage
    xorg.libxcb
    xorg.libXScrnSaver
    nss
    ffmpeg.lib
    cups
    pango
    cairo
    nspr
    atk
    libdrm
    glib
    dbus
    gtk3-x11
    mesa
    expat
    gdk-pixbuf
  ];

  # wrapProgramShell $out/opt/circuitjs1 \
  #  "''${gappsWrapperArgs[@]}" \
  #  --prefix LD_LIBRARY_PATH : ${libPath}:$out/lib \
  installPhase = ''
    mkdir -p $out/
    cp -r circuitjs1 $out/opt
    mkdir -p $out/lib
    cp circuitjs1/lib* $out/lib
    mkdir -p $out/bin
    ln -sf $out/opt/circuitjs1 $out/bin/circuitjs1

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}":$out/lib \
      $out/bin/circuitjs1
  '';

  meta = with lib; {
    # inherit homepage;
    description = "Falstad circuit simulator";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.therealr5 ];
  };
}
