{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";

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

    agenix.url = "github:ryantm/agenix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = 
    { 
      self, 
      nixpkgs,
      nixpkgs-25-05,
      agenix,
      ... 
    } @ inputs: {
      overlays.default = final: prev: let
        username = "michael";
        old = import nixpkgs-25-05 {
          system = prev.stdenv.hostPlatform.system or prev.system;
          config = {allowUnfree = true;};
        };  
      in {
        citrix_workspace = prev.citrix_workspace.overrideAttrs (oa: {
          # 1) feed legacy WebKitGTK 4.0 to satisfy libwebkit2gtk-4.0.so.37 & libjavascriptcoregtk-4.0.so.18
          buildInputs = (oa.buildInputs or []) ++ [old.webkitgtk_4_0];
          # 2) unmark the package as broken so evaluation proceeds
          meta = (oa.meta or {}) // {broken = false;};
        });
      };
      nixosConfigurations = {
	laptop = nixpkgs.lib.nixosSystem {
          system = "x64_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [
            ./configuration.nix
            agenix.nixosModules.default
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
