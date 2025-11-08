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

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # editors
    vim
    neovim
    nano

    # rust
    rustup

    # golang
    go
    gopls
    delve

    # zig
    zig
    zls

    # python
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
    pyright

    # ruby
    (ruby.withPackages (ps: with ps; [
      nokogiri
      pry
      bundler
      solargraph
    ]))

    # nodejs
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

    # lua
    (pkgs.lua5_1.withPackages (lp: with lp; [
      lua
      luarocks
      luacheck
    ]))
    lua-language-server
    stylua

    # c
    gcc
    gnumake 
    cmake 

    # assembly
    nasm

    # database
    sqlite

    # containers
    docker
    podman

    # utils, build tools, and libraries
    git
    lazygit
    just
    watchexec
    tree-sitter
    ripgrep
    fzf
    inotify-tools # is a set of command-line utilities for monitoring filesystem events
    tree
    jq
    bat
    curl
    xclip
    glibc # (GNU C Library) is the core library that provides the standard C functions used by most Linux applications and system programs 
    libselinux # provides an API for interacting with SELinux (Security-Enhanced Linux), a powerful access control system built into the Linux kernel.
    stdenv.cc.cc.lib   #  the runtime libraries provided by the C/C++ compiler used in the standard environment 
    zlib # a widely used software library for data compression.
    openssl
    glib # a low-level, general-purpose utility library written in C, forming the foundation of the GNOME ecosystem and many other Linux applications.
    binutils # a collection of binary tools used for handling object files, libraries, and executables in Unix-like systems. It’s an essential part of the toolchain for compiling and linking programs
    coreutils # a package containing the essential command-line utilities for Unix-like operating systems
    glibc.dev # the development files for the GNU C Library (). These are needed when compiling software that links against glibc
    pkg-config # a helper tool used in compiling and linking software, especially in C and C++ projects. It simplifies the process of discovering and using libraries
    openssl # full-featured open-source toolkit for implementing the Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols, as well as general-purpose cryptography.
    openssl.dev # in Nix refers to the development files for the OpenSSL library, which are needed when compiling software that uses OpenSSL
    protobuf # a mechanism for serializing structured data, developed by Google. It’s widely used for efficient data exchange between services and for storing structured information.
  ];

}
