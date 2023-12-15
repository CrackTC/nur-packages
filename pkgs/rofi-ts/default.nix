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
    rev = "5ba85ec4c8c0684739f30cb84e66d20765f60c71";
    hash = "sha256-ALZNM9heKSlJ6N+zk9EpAbTNlbt1EbMvod8aD5avo2Q=";
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
