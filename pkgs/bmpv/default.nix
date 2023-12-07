{ stdenv
, lib
, fetchFromGitHub
, bbdown
, danmaku2ass
, python3
, mpv
}:
let python = python3.withPackages (ps: with ps; [ requests ]); in
stdenv.mkDerivation {
  name = "bmpv";

  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "bmpv";
    rev = "main";
    sha256 = "sha256-YhxvUrO5mmZSptizwwNYUfTasq+WhHnDN6NGxosZk9M=";
  };

  buildInputs = [
    bbdown
    danmaku2ass
    python
    mpv
  ];

  installPhase = ''
    mkdir -p $out/share/applications
    mkdir -p $out/bin
    cp bmpv.desktop $out/share/applications
    cp ./bmpv.py $out/bin/bmpv
    chmod +x $out/bin/bmpv
  '';

  meta = with lib; {
    description = "play bilibili video in mpv";
    homepage = "https://github.com/CrackTC/bmpv";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "bmpv";
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
