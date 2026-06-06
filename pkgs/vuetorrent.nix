{ stdenv, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "vuetorrent";
  version = "2.34.0";

  src = fetchzip {
    url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
    sha256 = "sha256-MtTN4O1sCF7JhSzz218qrF+zNZEII09AhLxG6fCPIOk=";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    mv public $out
  '';
}
