{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # <https://github.com/nix-community/poetry2nix>
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # <https://github.com/nix-systems/nix-systems>
    systems.url = "github:nix-systems/default-linux";

    # <https://github.com/edolstra/flake-compat>
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.poetry2nix.lib) mkPoetry2Nix;

    eachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = eachSystem (system: import nixpkgs {localSystem = system;});
  in {
    packages = eachSystem (system: let
      inherit (mkPoetry2Nix {pkgs = pkgsFor.${system};}) mkPoetryApplication;
    in {
      default = self.packages.${system}.pyprland;
      pyprland = mkPoetryApplication {
        projectDir = nixpkgs.lib.cleanSource ./.;
        checkGroups = [];
      };
    });

    devShells = eachSystem (system: let
      inherit (mkPoetry2Nix {pkgs = pkgsFor.${system};}) mkPoetryEnv;
    in {
      default = self.devShells.${system}.pyprland;
      pyprland = pkgsFor.${system}.mkShellNoCC {
        packages = with pkgsFor.${system}; [
          (mkPoetryEnv {projectDir = ./.;})
          poetry
        ];
      };
    });
  };

  nixConfig = {
    extra-substituters = ["https://hyprland-community.cachix.org"];
    extra-trusted-public-keys = ["hyprland-community.cachix.org-1:5dTHY+TjAJjnQs23X+vwMQG4va7j+zmvkTKoYuSXnmE="];
  };
}
