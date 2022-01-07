{ pkgs, ... }:

{
  config = {
    home.packages = with pkgs;
      [
        cachix
        hydra-check
        nix-diff
        nix-du
        nix-info
        nix-prefetch-git
        nix-tree
        nixfmt
        nixpkgs-fmt
      ] ++ pkgs.lib.optional (pkgs.stdenv.isLinux) pkgs.nix-serve;

    home.stateVersion = "20.09";

    manual.manpages.enable = true;

    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
