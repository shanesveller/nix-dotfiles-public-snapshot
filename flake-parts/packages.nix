_inputs:

{
  perSystem = { config, pkgs, ... }:
    let
      callRustPackage = path:
        pkgs.callPackage path { inherit (pkgs.rustPlatform) buildRustPackage; };
    in {
      packages = {
        cargo-hack = callRustPackage ../pkgs/cargo-hack.nix;
        cargo-nextest = callRustPackage ../pkgs/cargo-nextest.nix;

        localPackages = pkgs.linkFarmFromDrvs "localPackages"
          (with config.packages; [ cargo-hack cargo-nextest emacs ]);

        nix-wrapper = pkgs.writeShellScriptBin "nix" ''
          ${pkgs.nix}/bin/nix --option experimental-features "nix-command flakes" "$@"
        '';
      };
    };
}
