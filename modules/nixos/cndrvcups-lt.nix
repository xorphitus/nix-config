# FIXME: This is an incomplete package because printing fails.
# There are also following issues:
# - /var/cache/Canon/ is not created
# - Just for improvement, it may be better to ensure `ar` command existence
{ fetchurl, lib, stdenv }:

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
