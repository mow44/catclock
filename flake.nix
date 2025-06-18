{
  description = "uxn catclock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "catclock";

              nativeBuildInputs = with pkgs; [
                uxn
              ];

              src = pkgs.fetchurl {
                url = "https://wiki.xxiivv.com/etc/catclock.tal.txt";
                sha256 = "sha256-yY4QuKKgUKSrCsIiMRBBxajzd94fNnKCGdg18UK0iNE="; # pkgs.lib.fakeSha256;
              };

              unpackPhase = ''
                cp $src catclock.tal
              '';

              patchPhase = ''
                substituteInPlace catclock.tal \
                --replace ".theme" "/home/a/.config/uxn/theme"
              '';

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
