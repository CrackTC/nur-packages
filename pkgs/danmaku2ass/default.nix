{ stdenv
, fetchFromGitHub
, python3
, gettext
, lib
}:
stdenv.mkDerivation {
  name = "danmaku2ass";
  src = fetchFromGitHub {
    owner = "m13253";
    repo = "danmaku2ass";
    rev = "master";
    sha256 = "sha256-Tr9od5Aj0jT2KPTVm7Mnpl0g+fFUsOWxKQA7BsWeiQM=";
  };

  nativeBuildInputs = [ gettext ];

  buildInputs = [ python3 ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install DESTDIR="" PREFIX="$out"
  '';

  meta = with lib; {
    description = "Convert comments from Niconico/AcFun/bilibili to ASS format";
    homepage = "https://github.com/m13253/danmaku2ass";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "danmaku2ass";
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
