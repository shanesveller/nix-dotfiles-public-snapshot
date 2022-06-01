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
        nixpkgs-review
      ] ++ pkgs.lib.optional (pkgs.stdenv.isLinux) pkgs.nix-serve;
  };
}
