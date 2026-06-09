{{
  description = "Roslyn Language Server (latest prerelease via buildDotnetGlobalTool)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Change if needed (aarch64-linux supported)
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.roslyn-language-server = pkgs.callPackage ./roslyn-language-server.nix {};

      # Home Manager module for easy import
      homeManagerModules.default = { pkgs, ... }: {
        home.packages = [ self.packages.${pkgs.system}.roslyn-language-server ];
      };

      # Optional: overlay
      overlays.default = final: prev: {
        roslyn-language-server = final.callPackage ./roslyn-language-server.nix {};
      };
