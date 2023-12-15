{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, wrapGAppsHook
, cairo
, glib
, gobject-introspection
, rofi-unwrapped
, translate-shell
}:
stdenv.mkDerivation {
  pname = "rofi-ts";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "rofi-ts";
    rev = "c8a867136591ae26c26975a87b9e848f7cef4f40";
    hash = "sha256-4qw6mwwWG/R3f9vP9a5LpdybO5usxSdyrpuz21raFmw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    cairo
    glib
    rofi-unwrapped
    translate-shell
  ];

  patches = [
    ./0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    sed "s|executable = \"trans\"|executable = \"${lib.makeBinPath [ translate-shell ]}/trans\"|" -i src/ts.c
  '';

  meta = with lib; {
    description = "Translate Shell plugin for Rofi";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
