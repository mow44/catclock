{
  description = "uxn catclock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    themes = {
      url = "github:mow44/themes/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      themes,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        uxn = pkgs.uxn;
        sourceFile = import ./source.nix {
          inherit pkgs themes;
        };
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "catclock";

              nativeBuildInputs = [
                uxn
              ];

              src = self;

              buildPhase = ''
                uxnasm ${sourceFile} catclock.rom
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
