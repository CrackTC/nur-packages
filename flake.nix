{
  description = "My personal NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = nixpkgs.legacyPackages.${system};
      });
      packages = forAllSystems (system: lib.filterAttrs (_: v: lib.isDerivation v) self.legacyPackages.${system});
    };
  nixConfig = {
    extra-substituters = [ "https://cracktc.cachix.org" ];
    extra-trusted-public-keys = [ "cracktc.cachix.org-1:2hSlXvkhNchqB0wo+nz13bWdJo9/nxrAi/masgZCm2I=" ];
  };
}
