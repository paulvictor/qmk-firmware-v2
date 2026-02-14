{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        # nixpkgs revision pinned by this flake
        legacyPackages = pkgs;

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs;[
              qmk
              # Add here tools you need in your development shell
            ];
          };
        };

        # derivations that we can run from CI
        checks = {
          trailing-whitespace = pkgs.build.checkTrailingWhitespace ./.;
          reuse-lint = pkgs.build.reuseLint ./.;
          # Uncomment in case your project sources contain bash scripts
          # shellcheck = pkgs.build.shellcheck ./.;
        };
      });
}
