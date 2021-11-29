with import <nixpkgs> { };
with pkgs;

{
  dockerShowContext = callPackage ./default.nix { };
}
