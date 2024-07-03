{ stdenv
, fetchFromGitHub
}:

let
  version = "unstable-2024-07-04";
  pname = "hpfan";
in
stdenv.mkDerivation rec {
  inherit version pname;
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "hpfan";
    rev = "c8479e52144c63574353cf273da46e707e291b21";
    hash = "sha256-H70jtZL1D3ZVAXgxuHsi1rCqrVl+SNJ/yFbNOk3UDTs=";
  };

  buildPhase = ''
    cc -Wall -Wextra -std=gnu99 -O2 -o hpfan hpfan.c
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp hpfan $out/bin

    runHook postInstall
  '';
}
