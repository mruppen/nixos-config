{
  description = "EasyDotnet - .NET tool for easy-dotnet.nvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        easyDotnet = pkgs.buildDotnetGlobalTool {
          pname = "EasyDotnet";
          version = "3.3.1";                    # Current latest (June 2026)
          
          nugetSource = "https://api.nuget.org/v3/index.json";
          sha256 = "sha256-/MCI2xjOiyqVK3qPqA0vVJG+ZZocna7zPDqo7H5CFt4=";
        };
      in
      {
        packages.default = easyDotnet;
        packages.easydotnet = easyDotnet;

        # For direct execution
        apps.default = {
          type = "app";
          program = "${easyDotnet}/bin/dotnet-easydotnet";
        };
      });
}
