{
  description = "Joel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stable Herdr release. Updates are controlled through flake.lock.
    herdr.url = "github:ogulcancelik/herdr/v0.7.5";

    nixvim.url = "github:nix-community/nixvim";

    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      mangowm,
      noctalia,
      pi,
      helium-browser,
      ...
    }:
    {
      nixosConfigurations.mainframe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/mainframe
          ./modules/desktop.nix

          mangowm.nixosModules.mango

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";

              extraSpecialArgs = {
                inherit inputs;
              };

              users.joel = import ./home/joel;
            };
          }
        ];
      };
    };
}
