{
  lib,
  stdenv,
  fetchurl,
  binutils,
  autoPatchelfHook,
  makeWrapper,
  cups,
  libxml2,
  gnome2,
  gtk2,
  glib,
  atk,
  gdk-pixbuf,
  pango,
  cairo,
  patchPpdFilesHook,
}:

# Reference: https://aur.archlinux.org/packages/cndrvcups-lt
stdenv.mkDerivation rec {
  pname = "cndrvcups-lt";
  version = "5.0.0";

  meta = with lib; {
    description = "Canon UFR II /LIPSLX Printer Driver. It provides ppd files for LBP112, LBP113, LBP151, LBP6030, LBP6230, LBP7110C, and LBP8100 printers.";
    homepage = "https://www.canon-europe.com/support/consumer/products/printers/i-sensys/lbp-series/i-sensys-lbp6030.html?type=drivers&language=EN&os=Linux%20(64-bit)";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };

  src = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz";
    sha256 = "sha256-RoiBQAFrwQlmlKD9b9P2rTk5cLgVN1Y3OjgtyCOQ8lk=";
  };

  nativeBuildInputs = [
    binutils # provides ar command
    autoPatchelfHook
    makeWrapper
    patchPpdFilesHook
  ];

  buildInputs = [
    cups
    cups.dev
    libxml2
    gnome2.libglade
    gtk2
    glib
    atk
    gdk-pixbuf
    pango
    cairo
    stdenv.cc.cc.lib # libstdc++
  ];

  # Tell autoPatchelfHook to ignore libxml2.so.2 - we'll create a compatibility symlink
  # The binaries use basic libxml2 API which is ABI-compatible with newer versions
  autoPatchelfIgnoreMissingDeps = [ "libxml2.so.2" ];

  dontStrip = true;

  unpackPhase = ''
    tar xzf "$src"
  '';

  installPhase = ''
    runHook preInstall

    cd linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian
    ar x cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb
    mkdir data
    tar -xzf data.tar.gz -C data
    cd data

    # Create CUPS directory structure
    mkdir -p "$out/lib/cups/filter"
    mkdir -p "$out/share/cups/model"

    # Install CUPS filter
    install -Dm755 usr/lib/cups/filter/rastertosfp "$out/lib/cups/filter/rastertosfp"

    # Install PPD files
    cp -r usr/share/cups/model/*.ppd "$out/share/cups/model/"

    # Install Canon libraries to $out/lib
    # Main libraries
    install -Dm755 usr/lib/libcanon_slimsfp.so.1.0.0 "$out/lib/libcanon_slimsfp.so.1.0.0"
    ln -s libcanon_slimsfp.so.1.0.0 "$out/lib/libcanon_slimsfp.so.1"
    ln -s libcanon_slimsfp.so.1 "$out/lib/libcanon_slimsfp.so"

    install -Dm755 usr/lib/libColorGearCsfp.so.2.0.0 "$out/lib/libColorGearCsfp.so.2.0.0"
    ln -s libColorGearCsfp.so.2.0.0 "$out/lib/libColorGearCsfp.so.2"
    ln -s libColorGearCsfp.so.2 "$out/lib/libColorGearCsfp.so"

    install -Dm755 usr/lib/libncapfilterr.so.1.0.0 "$out/lib/libncapfilterr.so.1.0.0"
    ln -s libncapfilterr.so.1.0.0 "$out/lib/libncapfilterr.so.1"
    ln -s libncapfilterr.so.1 "$out/lib/libncapfilterr.so"

    install -Dm755 usr/lib/libcnncapcmr.so.1.0 "$out/lib/libcnncapcmr.so.1.0"
    ln -s libcnncapcmr.so.1.0 "$out/lib/libcnncapcmr.so.1"
    ln -s libcnncapcmr.so.1 "$out/lib/libcnncapcmr.so"

    install -Dm755 usr/lib/libuictlncapr.so.1.0.0 "$out/lib/libuictlncapr.so.1.0.0"
    ln -s libuictlncapr.so.1.0.0 "$out/lib/libuictlncapr.so.1"
    ln -s libuictlncapr.so.1 "$out/lib/libuictlncapr.so"

    install -Dm755 usr/lib/libcaepcmsfp.so.1.0 "$out/lib/libcaepcmsfp.so.1.0"
    ln -s libcaepcmsfp.so.1.0 "$out/lib/libcaepcmsfp.so.1"
    ln -s libcaepcmsfp.so.1 "$out/lib/libcaepcmsfp.so"

    install -Dm755 usr/lib/libcanonncapr.so.1.0.0 "$out/lib/libcanonncapr.so.1.0.0"
    ln -s libcanonncapr.so.1.0.0 "$out/lib/libcanonncapr.so.1"
    ln -s libcanonncapr.so.1 "$out/lib/libcanonncapr.so"

    # Install Canon subdirectory libraries
    mkdir -p "$out/lib/Canon/CUPS_SFPR/Bidi"
    mkdir -p "$out/lib/Canon/CUPS_SFPR/Libs"
    mkdir -p "$out/lib/Canon/CUPS_SFPR/Bins"

    for lib in usr/lib/Canon/CUPS_SFPR/Bidi/*.so.*; do
      install -Dm755 "$lib" "$out/lib/Canon/CUPS_SFPR/Bidi/$(basename "$lib")"
    done

    for lib in usr/lib/Canon/CUPS_SFPR/Libs/*.so.*; do
      install -Dm755 "$lib" "$out/lib/Canon/CUPS_SFPR/Libs/$(basename "$lib")"
    done

    if [ -d usr/lib/Canon/CUPS_SFPR/Bins ]; then
      for bin in usr/lib/Canon/CUPS_SFPR/Bins/*; do
        install -Dm755 "$bin" "$out/lib/Canon/CUPS_SFPR/Bins/$(basename "$bin")"
      done
    fi

    # Install binaries (GUI utilities - optional, may not work on Wayland)
    mkdir -p "$out/bin"
    for bin in usr/bin/*; do
      install -Dm755 "$bin" "$out/bin/$(basename "$bin")"
    done

    # Install shared data files (ICC profiles, etc.)
    mkdir -p "$out/share"
    cp -r usr/share/caepcm "$out/share/" || true
    cp -r usr/share/cngplp2l "$out/share/" || true
    cp -r usr/share/locale "$out/share/" || true

    # Install udev rules
    mkdir -p "$out/etc/udev/rules.d"
    cp -r etc/udev/rules.d/* "$out/etc/udev/rules.d/"

    # Create libxml2.so.2 compatibility symlink
    # The Canon binaries were compiled against an older libxml2 with soname libxml2.so.2
    # but the API they use is ABI-compatible with the current libxml2
    ln -s ${libxml2.out}/lib/libxml2.so "$out/lib/libxml2.so.2"

    runHook postInstall
  '';

  # Register additional library paths for autoPatchelfHook
  preFixup = ''
    addAutoPatchelfSearchPath "$out/lib"
    addAutoPatchelfSearchPath "$out/lib/Canon/CUPS_SFPR/Bidi"
    addAutoPatchelfSearchPath "$out/lib/Canon/CUPS_SFPR/Libs"
  '';

  # The filter name that PPD files reference
  ppdFileCommands = [ "rastertosfp" ];

  # Wrap binaries with library paths for dlopen'd libraries
  postFixup =
    let
      libPath = lib.makeLibraryPath [
        cups
        libxml2
        gnome2.libglade
        gtk2
        glib
        atk
        gdk-pixbuf
        pango
        cairo
        stdenv.cc.cc.lib
      ] + ":$out/lib:$out/lib/Canon/CUPS_SFPR/Bidi:$out/lib/Canon/CUPS_SFPR/Libs";
    in
    ''
      # Wrap the CUPS filter with LD_LIBRARY_PATH for dlopen'd libraries
      wrapProgram "$out/lib/cups/filter/rastertosfp" \
        --prefix LD_LIBRARY_PATH : "${libPath}"

      # Wrap GUI utilities (they use GTK2 and libglade)
      for bin in "$out/bin"/*; do
        if [ -f "$bin" ] && [ -x "$bin" ]; then
          wrapProgram "$bin" \
            --prefix LD_LIBRARY_PATH : "${libPath}"
        fi
      done

      # Wrap Canon helper binaries
      for bin in "$out/lib/Canon/CUPS_SFPR/Bins"/*; do
        if [ -f "$bin" ] && [ -x "$bin" ]; then
          wrapProgram "$bin" \
            --prefix LD_LIBRARY_PATH : "${libPath}"
        fi
      done
    '';
}
