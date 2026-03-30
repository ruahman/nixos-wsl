{ config, pkgs, ... }:
let
  rust-version = "1.94.0";
  go-version = "1.26.1";
  zig-version = "0.15.2";
in
{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
      alias fg = job unfreeze
      def --env y [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
          cd $cwd
        }
        rm -f $tmp
      }
    '';
  };

  programs.starship = {
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
    # dioxus-cli
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
    (pkgs.buildEnv {
      name = "npm-packages";
      paths = with pkgs.nodePackages; [
        typescript
        eslint
        prettier
        vscode-langservers-extracted  # for HTML/CSS/JSON
        typescript-language-server
      ];
      # Optional: add node_modules/.bin to PATH
      pathsToLink = [ "/bin" ];
    })
    bun

    ## python
    (pkgs.python312.withPackages (ps: with ps; [
      ipython
      numpy
      pandas
      matplotlib
      jupyterlab 
      marimo
      pyzmq
      mypy
      ruff
      isort
    ]))
    pyright

    ## zig
    pkgs.zigpkgs.${zig-version}
    zls

    ## ruby
    (ruby.withPackages (ps: with ps; [
      nokogiri
      pry
      bundler
      solargraph
      rubocop
    ]))

    ## c/c++
    gcc
    # clang
    # clang-tools

    ## php
    php
    phpactor

    ## html,css,json
    vscode-langservers-extracted

    ## copilot
    copilot-language-server

    ## assembly
    nasm
    fasm

    ## database
    sqlite
    postgresql
    surrealdb
    couchdb3
    redis

    ## messaging
    (lib.lowPrio activemq)

    ## bitcoin
    bitcoind
    lnd
    taproot-assets

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
