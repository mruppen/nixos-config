{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #stylix.url = {
    #  url = "github:danth/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #zen-browser.url = "github:0xc000022070/zen-browser-flake";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    reaper-flake.url = "github:9Prestidigitator/reaper-flake";
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    noctalia,
    reaper-flake,
    ...
  } @ inputs: let
    username = "michael";
  in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs username;};
        modules = [
          ./configuration.nix
          agenix.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs username;};
              users.${username}.imports = [./home.nix];
            };
          }
        ];
      };
    };
  };
}
