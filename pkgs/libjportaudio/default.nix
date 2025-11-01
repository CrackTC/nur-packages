{ stdenv
, fetchFromGitHub
, jdk
, cmake
, portaudio
}:

let
  version = "0.1.0";
  pname = "libjportaudio";
in
stdenv.mkDerivation rec {
  inherit version pname;
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "ed2d3bc78b42f9c877863618b0ec4dac216102cc";
    sha256 = "sha256-tpJ4JqNFcuDmW70fLa0mW4fytjlU7h77IgMwS3msUX8=";
  };

  nativeBuildInputs = [ cmake portaudio ];

  preConfigure = ''
    export JAVA_HOME=${jdk}
  '';

  buildPhase = ''
    make jportaudio_0_1_0
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libjportaudio_0_1_0.so $out/lib/libjportaudio.so
  '';
}
