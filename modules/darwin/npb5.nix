{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (stdenvNoCC.mkDerivation rec {
      pname = "nux-mld";
      version = "2.1.12.16";

      src = fetchurl {
        url = "https://nux.cherubtechnology.com/download/Software/Effects/Verdugo/MLD/NUX_MLD_V2.1.12.16_macOS.zip";
        hash = "sha256-qri6aV51L+Vf3lQpLxT9jVzHU3tQIff/sXhYHsDPlJ0=";
      };

      nativeBuildInputs = [ unzip undmg ];

      unpackPhase = ''
        runHook preUnpack
        unzip -q $src
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/Applications"

        # Find the DMG file in the extracted contents
        dmg_file=$(find . -maxdepth 2 -name "*.dmg" -type f | head -1)

        if [ -z "$dmg_file" ]; then
          echo "Error: No DMG file found in the zip archive"
          exit 1
        fi

        # Extract DMG using undmg (works in sandbox)
        undmg "$dmg_file"

        # Find and copy the app bundle
        app_path=$(find . -maxdepth 2 -name "*.app" -type d | head -1)

        if [ -n "$app_path" ]; then
          cp -R "$app_path" "$out/Applications/"
        else
          echo "Error: No .app bundle found"
          exit 1
        fi

        runHook postInstall
      '';

      meta = with lib; {
        description = "NUX MLD - Digital audio workstation plugin";
        homepage = "https://nux.cherubtechnology.com/";
        platforms = platforms.darwin;
        license = licenses.unfree;
      };
    })
  ];
}