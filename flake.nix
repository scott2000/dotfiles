{
  description = "Configuration for Scott's computer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # TODO: update to current when citrix_workspace is fixed
    nixpkgs-citrix-workspace.url = "github:NixOS/nixpkgs/94def634a20494ee057c76998843c015909d6311";
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
      nixpkgs-citrix-workspace,
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

      packages.x86_64-linux.citrix-workspace-old =
        (import nixpkgs-citrix-workspace {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "libsoup-2.74.3"
            "libxml2-2.13.8"
          ];
        }).citrix_workspace;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
