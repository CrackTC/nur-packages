{ stdenv
, fetchFromGitHub
}:

let
  version = "v1.1.1";
  pname = "hpfan";
in
stdenv.mkDerivation rec {
  inherit version pname;
  name = "${pname}-${version}";
  src = fetchFromGitHub ({
    owner = "CrackTC";
    repo = "hpfan";
    rev = version;
    sha256 = "sha256-Bttq1pvTPbJIcXJV07cquL9Wgh0Vwgl5Pn62bvr+4IY=";
  });

  buildPhase = ''
    cc -Wall -Wextra -std=c99 -O2 -o hpfan hpfan.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hpfan $out/bin
  '';
}
