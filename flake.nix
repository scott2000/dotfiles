{
  description = "Configuration for Scott's computer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Use jujutsu flake to allow selecting unreleased versions easily
    jujutsu-latest.url = "github:jj-vcs/jj/main";
    # This plugin isn't available from nixpkgs
    vim-jjdescription-src = {
      url = "github:avm99963/vim-jjdescription";
      flake = false;
    };
    # I haven't added a flake for this yet
    jj-analyze-src = {
      url = "github:scott2000/jj-analyze/jj-0.38.0";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.scott-framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./scott-framework/configuration.nix
        ];
      };

      homeConfigurations.scott = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];
        extraSpecialArgs = inputs;
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
