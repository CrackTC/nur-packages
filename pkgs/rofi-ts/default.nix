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
  version = "unstable-2024-04-06";

  src = fetchFromGitHub {
    owner = "CrackTC";
    repo = "rofi-ts";
    rev = "cdb4f5c53d53d3439a455b3848b284d0e4d84b5a";
    hash = "sha256-t0g7+LPMCYGwJ9eJbTAYlC2LODZcr23JUgKjgadQYZk=";
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
