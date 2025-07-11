{ pkgs, lib, ... }:

# FIXME: requires Swift >= 6.0, but it's not available in the NixOS package repository, yet

let
  zenzaiModel = pkgs.fetchurl {
    url = "https://huggingface.co/Miwa-Keita/zenz-v3-small-gguf/resolve/main/ggml-model-Q5_K_M.gguf";
    sha256 = "sha256-UB9gXQiPW5iHkaAK4Z7UaYXtfEgUTzZLLz8flRybIIM=";
  };
in

pkgs.stdenv.mkDerivation rec {
  pname = "fcitx5-hazkey";
  version = "0.0.9";

  src = pkgs.fetchFromGitHub {
    owner = "7ka-Hiira";
    repo = "fcitx5-hazkey";
    rev = "${version}";
    sha256 = "sha256-Q2Ogl5ZUOGfmg+gDsWUgiTe2FKRc1+Dx/2KeZ0MEFgM=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    swiftPackages.swift
    swiftPackages.swiftpm
    gettext
  ];

  buildInputs = with pkgs; [
    fcitx5
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSKIP_ZENZAI_INSTALL=ON"
  ];

  prePatch = ''
    # Copy zenzai.gguf model file to expected location
    cp ${zenzaiModel} zenzai.gguf

    # Workaround for Swift library issue
    # https://github.com/swiftlang/swift/issues/78003
    mkdir -p swift_workaround/usr/lib/swift_static/linux

    # Find Swift library paths in the Nix store
    SWIFT_LIB_FILE=$(find ${pkgs.swift}/lib -name "libswiftCxx.a" | head -1)

    if [ -n "$SWIFT_LIB_FILE" ]; then
      SWIFT_LIB_PATH=$(dirname "$SWIFT_LIB_FILE")

      if [ -f "$SWIFT_LIB_PATH/libswiftCxx.a" ]; then
        cp "$SWIFT_LIB_PATH/libswiftCxx.a" swift_workaround/usr/lib/swift_static/linux/
      fi

      if [ -f "$SWIFT_LIB_PATH/libswiftCxxStdlib.a" ]; then
        cp "$SWIFT_LIB_PATH/libswiftCxxStdlib.a" swift_workaround/usr/lib/swift_static/linux/
      fi
    fi

    export SWIFT_WORKAROUND_PATH="$PWD/swift_workaround"
  '';

  configurePhase = ''
    runHook preConfigure

    mkdir -p build
    cd build

    # First cmake run (expected to fail but sets up environment)
    cmake $cmakeFlags -DCMAKE_INSTALL_PREFIX=$out .. || true

    # Second cmake run (should succeed)
    cmake $cmakeFlags -DCMAKE_INSTALL_PREFIX=$out ..

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cd build
    make -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cd build
    make install DESTDIR=$out

    # Move files from nested directory structure to proper locations
    if [ -d "$out/usr" ]; then
      cp -a $out/usr/* $out/
      rm -rf $out/usr
    fi

    # Handle x86_64-linux-gnu directory if it exists
    if [ -d "$out/lib/x86_64-linux-gnu" ]; then
      cp -a $out/lib/x86_64-linux-gnu/* $out/lib/
      rm -rf $out/lib/x86_64-linux-gnu
    fi

    # Set correct permissions
    if [ -f "$out/lib/fcitx5/fcitx5-hazkey.so" ]; then
      chmod +x $out/lib/fcitx5/fcitx5-hazkey.so
    fi

    if [ -f "$out/lib/libhazkey.so" ]; then
      chmod +x $out/lib/libhazkey.so
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "fcitx5 input method for hazkey keyboard layout";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.unfree; # Check actual license in repository
    platforms = platforms.linux;
    maintainers = [ ];
    broken = false;
  };
}
