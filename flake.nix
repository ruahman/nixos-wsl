{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # so that all other inputs use the same version of nixpkgs in order to avoid duplication
    nixos-wsl = {
	    url = "github:nix-community/NixOS-WSL";
	    inputs.nixpkgs.follows = "nixpkgs";
    };
    zig-overlay = {
	    url = "github:mitchellh/zig-overlay";
	    inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
        url = "github:oxalica/rust-overlay";
	      inputs.nixpkgs.follows = "nixpkgs";
    };
    go-overlay = {
        url = "github:purpleclay/go-overlay";
	      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
	    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, zig-overlay, rust-overlay, go-overlay, claude-code-nix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-wsl.nixosModules.default
        ./configuration.nix
        {
          nixpkgs.overlays = [ 
            zig-overlay.overlays.default 
            rust-overlay.overlays.default
            go-overlay.overlays.default
            claude-code-nix.overlays.default
          ];
        }
      ];
    };
  };
}
