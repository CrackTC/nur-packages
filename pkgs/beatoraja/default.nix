{ lib
, stdenv
, fetchzip
, oraclejre8
, unzip
, openal
, xrandr
, makeWrapper
, libjportaudio
}:

let
  jre = oraclejre8.overrideAttrs {
    src = fetchTarball {
      url = "https://static.sora.zip/nix/jdk-8u281-linux-x64.tar.gz";
      sha256 = "0f9fb37p75cf7qfm67yc8ariqksnw8641kh2zcwvlrr4r8lgj70v";
    };
  };
  pname = "beatoraja-modernchic";
  version = "0.8.6";
  fullName = "beatoraja${version}-modernchic";
in
stdenv.mkDerivation {
  inherit pname version;
  name = "${pname}-${version}";
  src = fetchzip {
    url = "https://mocha-repository.info/download/${fullName}.zip";
    hash = "sha256-IuaKRMXnmnqTdcXNncf8MCZwyusARjuzZL0IIFp8few=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  preInstall = ''
    rm beatoraja-config.*
    echo "#!/bin/sh" > beatoraja.sh

    echo 'if [ ! -d "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja" ]; then' >> beatoraja.sh

    echo 'mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> beatoraja.sh
    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> beatoraja.sh

    echo "cp -r $out/share/beatoraja/bgm ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/defaultsound ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/folder ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/ir ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/skin ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/sound ./" >> beatoraja.sh
    echo "cp -r $out/share/beatoraja/table ./" >> beatoraja.sh

    echo "find . -type d -exec chmod 755 {} \;" >> beatoraja.sh
    echo "find . -type f -exec chmod 644 {} \;" >> beatoraja.sh

    echo "fi" >> beatoraja.sh

    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> beatoraja.sh
    echo "exec ${jre}/bin/java -Xms1g -Xmx4g -jar '$out/share/beatoraja/beatoraja.jar'" >> beatoraja.sh
    chmod +x beatoraja.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    mkdir -p $out/bin
    mv beatoraja.sh $out/bin/beatoraja
    mv * $out/share/beatoraja/

    wrapProgram $out/bin/beatoraja \
      --prefix PATH : "${xrandr}/bin" \
      --prefix LD_LIBRARY_PATH : "${openal}/lib" \
      --prefix LD_LIBRARY_PATH : "${libjportaudio}/lib" \
      --prefix LD_PRELOAD : "${openal}/lib/libopenal.so" \
      --prefix LD_PRELOAD : "${libjportaudio}/lib/libjportaudio.so" \
      --prefix _JAVA_OPTIONS : "-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform rhythm game based on Java and libGDX.";
    homepage = "https://github.com/exch-bms2/beatoraja";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "beatoraja";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
