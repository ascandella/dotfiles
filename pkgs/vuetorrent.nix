{ stdenv, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "vuetorrent";
  version = "2.25.0";

  src = fetchzip {
    url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
    sha256 = "sOaQNw6AnpwNFEextgTnsjEOfpl3/lpoOZFgFOz7Bos=";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    mv public $out
  '';
}
