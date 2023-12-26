{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, wrapGAppsHook
, cairo
, glib
, rofi-unwrapped
, translate-shell
}:
stdenv.mkDerivation {
  pname = "rofi-ts";
  version = "unstable-2023-12-26";

  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "rofi-ts";
    rev = "35d3cd90e04ed85f77f91d1b5d004cad784ed944";
    hash = "sha256-5pdmI5EXg0fRCfwYxzXtimS176OZ68j1GXX0qy66C3M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
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
