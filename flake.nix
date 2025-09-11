{
  description = "glostis' Nixos and Home Manager configurations";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Color scheme detection was broken by https://github.com/ghostty-org/ghostty/pull/5064 (first introduced in v1.1.0)
    # and was fixed in https://github.com/ghostty-org/ghostty/pull/6007 (unreleased for now).
    # Falling back to a nixpkgs version that provides v1.0.1
    nixpkgs-ghostty.url = "github:nixos/nixpkgs/c44821d5fcbe4797868daa0838002577105a161f";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nurpkgs = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-compress-plugin = {
      url = "github:KKV9/compress.yazi";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-ghostty,
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
        ./nixos/suzanne/configuration.nix
      ];
    };
    nixosConfigurations.hector = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./nixos/hector/configuration.nix
      ];
    };
    homeConfigurations."glostis@fr-glostis-xps" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlays.default
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
        pkgs-stable = import nixpkgs-stable {system = system;};
        pkgs-ghostty = import nixpkgs-ghostty {system = system;};
        inherit nix-colors;
        enableWorkProfile = true;
        inherit nixgl;
        inherit inputs;
      };
    };
    homeConfigurations."glostis@suzanne" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlays.default
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
        pkgs-ghostty = import nixpkgs-ghostty {system = system;};
        inherit nix-colors;
        enableWorkProfile = false;
        inherit inputs;
      };
    };
    homeConfigurations."glostis@hector" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlays.default
        ];
      };

      modules = [
        ./home-manager/home.nix
        ./home-manager/terminal
      ];

      # The arguments here are passed to all modules
      extraSpecialArgs = {
        nixpkgsflake = nixpkgs;
        inherit inputs;
      };
    };
  };
}
