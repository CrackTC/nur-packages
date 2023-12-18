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
  version = "unstable-2023-12-18";

  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "rofi-ts";
    rev = "8f78e633d48c10413992f98be61c09409335be5f";
    hash = "sha256-rx3AyBRdkzAg595qFnVFTPOwWwDEd32LX++wHrJ+kCA=";
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
