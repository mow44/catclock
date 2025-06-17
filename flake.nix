{
  description = "uxn catclock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        uxn = pkgs.uxn;
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "catclock";
              version = "1.0";

              nativeBuildInputs = with pkgs; [
                uxn
              ];

              src = self;

              buildPhase = ''
                uxnasm catclock.tal catclock.rom
              '';

              installPhase = ''
                mkdir -p $out/bin
                cp catclock.rom $out/bin
              '';
            };
        };
      }
    );
}
