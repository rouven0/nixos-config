{ stdenv, fetchurl, lib, libX11, libXext, alsa-lib, freetype, curlWithGnuTls, ... }:
stdenv.mkDerivation rec {
  pname = "X32-Edit";
  version = "4.3";
  # version = "4.1";

  src = fetchurl {
    url = "https://mediadl.musictribe.com/download/software/behringer/X32/X32-Edit_LINUX_${version}.tar.gz";
    sha256 = "iVBBW6qVtEGlNXqKRZxObB9WfbOEjXMA1Nsp1CTFOH4=";
    # sha256 = "YyxrXWRapTj31dEv4pGFt4zZf+kb4TunPigyVh0+XH8=";
  };

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin
  '';
  preFixup =
    let
      # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
      libPath = lib.makeLibraryPath [
        curlWithGnuTls
        # libX11 # libX11.so.6
        # libXext # libXext.so.6
        alsa-lib # libasound.so.2
        freetype # libfreetype.so.6
        stdenv.cc.cc.lib # libstdc++.so.6
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/bin/${pname}
    '';

  meta = with lib; {
    homepage = "https://www.behringer.com/behringer/product?modelCode=P0ASF";
    description = "Editor for the behringer x32 digital mixer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
