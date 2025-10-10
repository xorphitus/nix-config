# https://discord.com/channels/428916969283125268/681876093107699736/1340490353240703028

{
  appimageTools,
  fetchurl,
  libgpg-error,
}:
let
  pname = "immersed-custom";
  version = "10.6.0";
  source = fetchurl {
    url = "https://web.archive.org/web/20241229041449/https://static.immersed.com/dl/Immersed-x86_64.AppImage";
    hash = "sha256-u07QpGXEXbp7ApZgerq36x+4Wxsz08YAruIVnZeS0ck=";
  };
  src = appimageTools.extract {
    inherit pname version;
    src = source;

    # Because of https://github.com/NixOS/nixpkgs/issues/267408
    postExtract = ''
      cp ${libgpg-error}/lib/* $out/usr/lib/
    '';
  };
  extraPkgs =
    pkgs: with pkgs; [
      libgpg-error
      fontconfig
      libGL
      libgbm
      wayland
      pipewire
      fribidi
      harfbuzz
      freetype
      libthai
      e2fsprogs
      zlib
      libp11
      xorg.libX11
      xorg.libSM

      # Added:
      egl-wayland
    ];
in
  appimageTools.wrapAppImage {
    inherit
      pname
      version
      src
      extraPkgs
    ;
  }
