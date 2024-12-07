{ stdenv, fetchzip, ... }:

stdenv.mkDerivation rec {
  pname = "gitea-catppucin";
  version = "1.0.1";

  src = fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v${version}/catppuccin-gitea.tar.gz";
    sha256 = "bJyI7RvVCf0M5vs8Qi+uAHv74CWxSDZ0Bb6zWJ4x4CM=";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    mv public $out
  '';
}
