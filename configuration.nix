# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
   
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.configurationLimit = 5;

  users.users.nixos = {
    shell = pkgs.nushell;
  };

  environment.systemPackages = with pkgs; [
    vim
    tmux
    emacs
    nano
    git
    lazygit
    fastfetch
    oh-my-posh

    ## neovim
    neovim
    (pkgs.lua5_1.withPackages (lp: with lp; [
      lua
      luarocks
      luacheck
    ]))
    lua-language-server
    stylua
    tree-sitter
    ripgrep
    fzf
    xclip

    ## containers
    docker
    podman

    # AI Agents
    claude-code
  ];

  # Add to all users' bashrc
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nixos = import ./home.nix;

  environment.interactiveShellInit = ''
    fastfetch
    eval "$(oh-my-posh init bash)"
  '';

}
