{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    rust-overlay.url = "github:oxalica/rust-overlay";
    go-overlay.url = "github:purpleclay/go-overlay";
  };

  outputs = { self, nixpkgs, zig-overlay, rust-overlay, go-overlay, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        {
          nixpkgs.overlays = [ 
            zig-overlay.overlays.default 
            rust-overlay.overlays.default
            go-overlay.overlays.default
          ];
        }
      ];
    };
  };
}
