{ buildPythonPackage
, fetchPypi
, hatchling
, hatch-vcs
, black
, ...
}: buildPythonPackage rec {
  pname = "pyink";
  version = "24.3.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CsQYh1Rh/Kc7S6hbSaa0WYrM2+AD7x8xxcXXLCo1Tdo=";
  };
  format = "pyproject";
  propagatedBuildInputs = [
    hatchling
    hatch-vcs
    (black.overrideAttrs (super: {
      version = "24.3.0";
      src = fetchPypi {
        inherit (super) pname;
        inherit version;
        sha256 = "sha256-oMnEoHca/GkZV4zscc6Co+MeBUkE5xl96svJOCZxxB8=";
      };
    }))
  ];
}
