{ config, pkgs, ... }:
let
  rust-version = "1.98.0";
  go-version = "1.26.7";
  zig-version = "0.16.0";
in
{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
    extraConfig = ''
      fastfetch
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  home.packages = with pkgs; [

    ## rust
    (rust-bin.stable.${rust-version}.default.override {
      extensions = [
        "rust-src"      # Required for rust-analyzer
        "rust-analyzer" # LSP server for IDEs
      ];
    })

    vscode-extensions.vadimcn.vscode-lldb.adapter

    ## golang
    go-bin.versions.${go-version}
    gopls
    golangci-lint
    delve
    gofumpt
    golines
    # solves bundler conflict with ruby
    (lib.lowPrio gotools)

    ## nodejs
    nodejs
    typescript
    typescript-language-server
    tsx 
    eslint
    prettier

    ## python
    python314
    python314Packages.ipython
    python314Packages.numpy
    python314Packages.pandas
    python314Packages.matplotlib
    python314Packages.pyzmq
    marimo
    mypy
    isort
    ruff
    pyright

    ## zig
    pkgs.zigpkgs.${zig-version}
    zls

    ## ruby
    ruby 
    rubyPackages.nokogiri
    pry
    rubocop
    solargraph
    # bundler

    ## c/c++
    gcc
    # (lib.lowPrio clang)
    # clang
    # clang-tools

    ## php
    php
    phpactor

    ## html,css,json
    vscode-langservers-extracted

    ## assembly
    nasm

    ## database
    sqlite


    ## bitcoin
    #bitcoind
    #lnd
    #taproot-assets

    ## tools
    gnumake 
    cmake 
    just
    watchexec
    inotify-tools # is a set of command-line utilities for monitoring filesystem events
    tree
    jq
    bat
    curl
    lf

    ## libraries
    pkg-config # a helper tool used in compiling and linking software, especially in C and C++ projects. It simplifies the process of discovering and using libraries
    openssl # full-featured open-source toolkit for implementing the Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols, as well as general-purpose cryptography.
    openssl.dev # in Nix refers to the development files for the OpenSSL library, which are needed when compiling software that uses OpenSSL
    protobuf # a mechanism for serializing structured data, developed by Google. It’s widely used for efficient data exchange between services and for storing structured information.
    glibc # (GNU C Library) is the core library that provides the standard C functions used by most Linux applications and system programs 
    libselinux # provides an API for interacting with SELinux (Security-Enhanced Linux), a powerful access control system built into the Linux kernel.
    stdenv.cc.cc.lib   #  the runtime libraries provided by the C/C++ compiler used in the standard environment 
    zlib # a widely used software library for data compression.
    openssl
    glib # a low-level, general-purpose utility library written in C, forming the foundation of the GNOME ecosystem and many other Linux applications.
    binutils # a collection of binary tools used for handling object files, libraries, and executables in Unix-like systems. It’s an essential part of the toolchain for compiling and linking programs
    coreutils # a package containing the essential command-line utilities for Unix-like operating systems
    glibc.dev # the development files for the GNU C Library (). These are needed when compiling software that links against glibc
  ];
}
