{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook3
, makeWrapper
, autoPatchelfHook
, udev
, libdrm
, libpqxx
, unixODBC
, gst_all_1
, pulseaudio
, alsa-lib
, qtwayland
, libmysqlconnectorcpp
, xcbutilcursor
}:

stdenv.mkDerivation rec {
  pname = "freedownloadmanager";
  version = "6.20.0";

  src = fetchurl {
    url = "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
    hash = "sha256-C7zFB6TSYDe4MSYdxqDcuYgv0WTWDe9BCzv2UVCS9Ow=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  dontWrapQtApps = true;
  autoPatchelfIgnoreMissingDeps = [ "libmimerapi.so" ];

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
    pulseaudio
    alsa-lib
    qtwayland
    makeWrapper
  ];

  buildInputs = [
    libdrm
    libpqxx
    unixODBC
    stdenv.cc.cc
    libmysqlconnectorcpp
    xcbutilcursor
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt/freedownloadmanager $out
    cp -r usr/share $out
    ln -s $out/freedownloadmanager/fdm $out/bin/${pname}

    substituteInPlace $out/share/applications/freedownloadmanager.desktop \
      --replace 'Exec=/opt/freedownloadmanager/fdm' 'Exec=${pname}' \
      --replace "Icon=/opt/freedownloadmanager/icon.png" "Icon=$out/freedownloadmanager/icon.png"
  '';

  meta = with lib; {
    description = "A smart and fast internet download manager";
    homepage = "https://www.freedownloadmanager.org";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
