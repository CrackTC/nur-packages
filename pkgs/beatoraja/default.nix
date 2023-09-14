{ stdenv
, fetchurl
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
  version = "0.8.5";
  fullName = "beatoraja${version}-modernchic";
in
stdenv.mkDerivation {
  inherit pname version;
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://mocha-repository.info/download/${fullName}.zip";
    sha256 = "HiP+8hnPVKveyCGiXJaZrSca152OFW88aRybZTutYDI=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  preInstall = ''
    rm ${fullName}/beatoraja-config.*
    echo "#!/bin/sh" > ${fullName}/beatoraja.sh

    echo 'if [ ! -d "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja" ]; then' >> ${fullName}/beatoraja.sh

    echo 'mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> ${fullName}/beatoraja.sh
    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> ${fullName}/beatoraja.sh

    echo "cp -r $out/share/beatoraja/bgm ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/defaultsound ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/folder ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/ir ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/skin ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/sound ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/table ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/beatoraja.jar ./" >> ${fullName}/beatoraja.sh

    echo "find . -type d -exec chmod 755 {} \;" >> ${fullName}/beatoraja.sh
    echo "find . -type f -exec chmod 644 {} \;" >> ${fullName}/beatoraja.sh

    echo "fi" >> ${fullName}/beatoraja.sh

    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> ${fullName}/beatoraja.sh
    echo "exec ${jre}/bin/java -Xms1g -Xmx4g -jar './beatoraja.jar'" >> ${fullName}/beatoraja.sh
    chmod +x ${fullName}/beatoraja.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    mkdir -p $out/bin
    mv ${fullName}/beatoraja.sh $out/bin/beatoraja
    mv ${fullName}/* $out/share/beatoraja/

    wrapProgram $out/bin/beatoraja \
      --prefix PATH : "${xrandr}/bin" \
      --prefix LD_LIBRARY_PATH : "${openal}/lib" \
      --prefix LD_LIBRARY_PATH : "${libjportaudio}/lib" \
      --prefix LD_PRELOAD : "${openal}/lib/libopenal.so" \
      --prefix LD_PRELOAD : "${libjportaudio}/lib/libjportaudio.so" \
      --prefix _JAVA_OPTIONS : "-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

    runHook postInstall
  '';
}
