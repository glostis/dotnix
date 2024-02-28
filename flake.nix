{
  description = "glostis' Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    home-manager,
    nurpkgs,
    nix-colors,
    nixgl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    homeConfigurations."glostis@fr-glostis-xps" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        overlays = [
          nurpkgs.overlay
          nixgl.overlay
        ];
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home-manager/home.nix
        ./home-manager/terminal
        ./home-manager/graphical
        ./home-manager/xps.nix
        # There's probably a more elegant way to do this...
        (import ./home-manager/graphical/firefox {enableWorkProfile = true;})
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        nixpkgsflake = nixpkgs;
        inherit nix-colors;
      };
    };
  };
}
