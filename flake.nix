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
  };

  outputs = { nixpkgs, home-manager, nurpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
    in {
      homeConfigurations."glostis@fr-glostis-xps" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
        system = system;
          overlays = [
            nurpkgs.overlay
          ];
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home-manager/home.nix
          ./home-manager/terminal.nix
          ./home-manager/graphical.nix
          ./home-manager/xps.nix
          ./home-manager/zsh
          ./home-manager/neovim
          ./home-manager/tmux
          (import ./home-manager/firefox {enableWorkProfile = true;})
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { nixpkgsflake = nixpkgs; };
      };
    };
}
