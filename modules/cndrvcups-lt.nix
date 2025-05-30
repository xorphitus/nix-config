# FIXME: This is an incomplete package because printing fails. The following may be causes:
# - binaries uses DLLs, which NixOS doesn't support with a straight forward way
# - /var/cache/Canon/ is not created
# - Some dependencies are not defined, which the binaries requires
# - Just for improvement, it may be better to ensure `ar` command existence
#
# Investigation:
#
# $ journalctl -u cups
#
# May 30 17:56:27 nixos cupsd[104139]: [Job 2] Could not start dynamically linked executable: LBP6030
# May 30 17:56:27 nixos cupsd[104139]: [Job 2] NixOS cannot run dynamically linked executables intended for generic
# May 30 17:56:27 nixos cupsd[104139]: [Job 2] linux environments out of the box. For more information, see:
# May 30 17:56:27 nixos cupsd[104139]: [Job 2] https://nix.dev/permalink/stub-ld
# May 30 17:56:27 nixos cupsd[104139]: [Job 2] PID 104345 (/nix/store/ra4bn2rlgy1x558xlvd8dj9nxhgjliij-cups-progs/lib/cups/filter/rastertosfp) stopped with status 127 (File too large)
{ fetchurl, lib, pkgs, stdenv }:

# Reference: https://aur.archlinux.org/packages/cndrvcups-lt
stdenv.mkDerivation rec {
  pname = "cndrvcups-lt";
  version = "5.0.0";

  meta = with lib; {
    description = "Canon UFR II /LIPSLX Printer Driver. It provides ppd files for LBP112, LBP113, LBP151, LBP6030, LBP6230, LBP7110C, and LBP8100 printers.";
    homepage = "https://www.canon-europe.com/support/consumer/products/printers/i-sensys/lbp-series/i-sensys-lbp6030.html?type=drivers&language=EN&os=Linux%20(64-bit)";
    license = licenses.unfree;
    platforms = platforms.linux;
  };

  src = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz";
    sha256 = "sha256-RoiBQAFrwQlmlKD9b9P2rTk5cLgVN1Y3OjgtyCOQ8lk=";
  };

  unpackPhase = ''
    tar xzf "$src"
  '';

  installPhase = ''
    mkdir -p "$out"

    cd linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian
    ar x cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb
    mkdir data
    tar -xzf data.tar.gz -C data
    cd data
    cp -r usr/bin/ "$out/bin/"
    cp -r usr/lib/ "$out/lib/"
    cp -r usr/share/ "$out/share/"
    cp -r etc/ "$out/etc/"
  '';
}
