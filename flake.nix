{
  description = "Configuration for Scott's computer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # TODO: update to current when Zoom screen sharing is fixed
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    # TODO: update to current when citrix_workspace is fixed
    nixpkgs-25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Use jujutsu flake to allow selecting unreleased versions easily
    jujutsu-latest.url = "github:jj-vcs/jj/main";
    # This plugin isn't available from nixpkgs
    vim-jjdescription = {
      url = "github:avm99963/vim-jjdescription";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-24_05,
      nixpkgs-25_05,
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

      # Old version of Zoom since new version has broken screen sharing
      packages.x86_64-linux.zoom-us-old =
        (import nixpkgs-24_05 {
          system = "x86_64-linux";
          config.allowUnfree = true;
        }).zoom-us;

      packages.x86_64-linux.citrix-workspace-old =
        (import nixpkgs-25_05 {
          system = "x86_64-linux";
          config.allowUnfree = true;
        }).citrix_workspace;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
