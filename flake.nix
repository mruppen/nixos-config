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
    
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = 
    { 
      self, 
      nixpkgs, 
      ... 
    }@inputs:
    let
      username = "michael";
    in
    {
      nixosConfigurations = {
	laptop = nixpkgs.lib.nixosSystem {
          system = "x64_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager 
            {
	      home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs username; };
                users.${username}.imports = [ ./home.nix ];
	      }; 
	    }
	  ];
        };
      };
    };
}
