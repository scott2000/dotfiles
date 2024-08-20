{
  description = "Configuration for Scott's computer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Required to fix "command not found" error message being broken
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # This plugin isn't available from nixpkgs
    vim-jjdescription = {
      url = "github:avm99963/vim-jjdescription/main";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nix-index-database,
      ...
    }@inputs:
    {
      nixosConfigurations.scott-framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          nix-index-database.nixosModules.nix-index
          ./scott-framework/configuration.nix
        ];
      };

      homeConfigurations.scott = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          nix-index-database.hmModules.nix-index
          ./home.nix
        ];
        extraSpecialArgs = inputs;
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
