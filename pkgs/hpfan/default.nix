{ stdenv
, fetchFromGitHub
}:

let
  version = "unstable-2024-01-09";
  pname = "hpfan";
in
stdenv.mkDerivation rec {
  inherit version pname;
  name = "${pname}-${version}";
  src = fetchFromGitHub ({
    owner = "CrackTC";
    repo = "hpfan";
    rev = "67f608e1eea9d0dce9626652da211472a0e4ebd9";
    sha256 = "sha256-OcLR388oW56RIicCPDmrWn27olnk3j+iRLn7tKiggbI=";
  });

  buildPhase = ''
    cc -Wall -Wextra -std=c99 -O2 -o hpfan hpfan.c
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp hpfan $out/bin

    runHook postInstall
  '';
}
