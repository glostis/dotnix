{
  description = "glostis' Nixos and Home Manager configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nurpkgs.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nurpkgs,
    nix-colors,
    nixgl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.suzanne = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./nixos/configuration.nix
      ];
    };
    homeConfigurations."glostis@fr-glostis-xps" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlay
          nixgl.overlay
        ];
      };

      modules = [
        ./home-manager/home.nix
        ./home-manager/terminal
        ./home-manager/graphical
        ./home-manager/xps.nix
        ./home-manager/graphical/firefox
      ];

      # The arguments here are passed to all modules
      extraSpecialArgs = {
        nixpkgsflake = nixpkgs;
        pkgs-stable = import nixpkgs {system = system;};
        inherit nix-colors;
        enableWorkProfile = true;
      };
    };
    homeConfigurations."glostis@suzanne" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlay
        ];
      };

      modules = [
        ./home-manager/home.nix
        ./home-manager/terminal
        ./home-manager/graphical
        ./home-manager/suzanne.nix
        ./home-manager/graphical/firefox
      ];

      # The arguments here are passed to all modules
      extraSpecialArgs = {
        nixpkgsflake = nixpkgs;
        pkgs-stable = import nixpkgs {system = system;};
        inherit nix-colors;
        enableWorkProfile = true;
      };
    };
  };
}
