{ stdenv, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "vuetorrent";
  version = "2.7.2";

  src = fetchzip {
    url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
    sha256 = "bJyI7RvVCf0M5vs8Qi+uAHv74CWxSDZ0Bb6zWJ4x4CM=";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    mv public $out
  '';
}
