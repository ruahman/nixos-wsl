# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    vim
    neovim
    rustup
    go
    gopls
    delve
    zig
    zls
    pyright
    (pkgs.python3.withPackages (ps: with ps; [
      ipython
      pytest
      requests
      numpy
      pandas
      matplotlib
      jupyterlab 
      marimo
      flask
      pyzmq
      mypy
      ruff
      isort
    ]))
    (ruby.withPackages (ps: with ps; [
      nokogiri
      pry
      bundler
      solargraph
    ]))
    nodejs
    (pkgs.buildEnv {
      name = "npm-packages";
      paths = with pkgs.nodePackages; [
        typescript
        ts-node
        eslint
        prettier
        vscode-langservers-extracted  # for HTML/CSS/JSON
        typescript-language-server
      ];
      # Optional: add node_modules/.bin to PATH
      pathsToLink = [ "/bin" ];
    })
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.luacheck
    lua-language-server
    stylua
    tree-sitter
    sqlite
    ripgrep
    fzf
    tree
    jq
    bat
    gcc
    gnumake 
    cmake 
    binutils 
    glibc.dev 
    pkg-config
    openssl
    openssl.dev
    protobuf
    nasm
    just
    watchexec
    git
    lazygit
  ];

}
