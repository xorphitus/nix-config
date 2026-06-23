{
  appimageTools,
  fetchurl,
  gtk-layer-shell,
}:
let
  pname = "handy";
  version = "0.8.3";
  src = fetchurl {
    url = "https://github.com/cjpais/Handy/releases/download/v${version}/Handy_${version}_amd64.AppImage";
    hash = "sha256-8rQJVpABydLXGlyLNIdw/cilAcmwvmAb93VoaJJ+KJQ=";
  };
  extraPkgs =
    pkgs: with pkgs; [
      gtk-layer-shell # required at runtime: libgtk-layer-shell.so.0
    ];
in
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      extraPkgs
    ;
  }
