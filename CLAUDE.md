# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Apply system changes:
```
sudo nixos-rebuild switch --flake .#nixos
```

Update all flake inputs:
```
nix flake update
```

Update a single input:
```
nix flake update <input-name>
```

## Architecture

Single-file NixOS configuration using Flakes. All system configuration lives in `configuration.nix`; `flake.nix` wires together inputs and passes overlays into nixpkgs.

### Flake Inputs

| Input | Purpose |
|-------|---------|
| nixpkgs (nixos-unstable) | Core packages |
| nixos-wsl | WSL integration |
| zig-overlay | Pinned Zig version |
| rust-overlay | Pinned Rust version |
| go-overlay | Pinned Go version |
| claude-code-nix | Claude Code integration |

### Version Pinning Pattern

Language versions are pinned at the top of `configuration.nix`:
```nix
let
  rust-version = "1.92.0";
  zig-version  = "0.15.2";
  go-version   = "1.25.5";
in
```

To change a language version, update the variable here and run `nixos-rebuild switch`.

### WSL-Specific Settings

`wsl.enable = true` and `wsl.defaultUser = "nixos"` are set in `configuration.nix`. The `nix-ld` option is enabled for running unpatched Linux binaries.
