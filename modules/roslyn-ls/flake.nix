{
  description = "Roslyn Language Server (latest prerelease via Nixpkgs unstable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Change to aarch64-linux if on ARM
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in {
      overlays.default = final: prev: {
        roslyn-language-server = final.roslyn-ls; # Alias for convenience
      };

      packages.${system}.default = pkgs.roslyn-ls;

      # For easy use in home-manager
      homeManagerModules.default = { pkgs, ... }: {
        home.packages = [ pkgs.roslyn-ls ];
      };
    };
}
