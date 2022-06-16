{
  description = "Shane Sveller's Nix/NixOS configurations";

  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-arm.url = "nixpkgs/nixos-22.05-aarch64";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-22.05";
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unstable.url = "nixpkgs/nixos-unstable";
  };

  # nixConfig = {
  #   extra-substituters = [ "https://shanesveller.cachix.org" ];
  #   extra-trusted-public-keys = [
  #     "shanesveller.cachix.org-1:SzmUXrd5XqRW5dQzm2dT6CJjT7/iudnoLzOAHj8hK6o="
  #   ];
  # };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self; } {
      imports = [ ./flake-parts ];
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    };
}
