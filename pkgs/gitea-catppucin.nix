{ stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "gitea-catppucin";
  version = "1.0.1";

  src = fetchTarball {
    url = "https://github.com/catppuccin/gitea/releases/download/v${version}/catppuccin-gitea.tar.gz";
    sha256 = "1qpy39j9an1b78kgy2rwpf49wkxv90jxq422f27bh8yj1nw6bpks";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    mv public $out
  '';
}
