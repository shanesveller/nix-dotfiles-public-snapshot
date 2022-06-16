_inputs: {
  perSystem = { pkgs, self', system, ... }:
    let
      gcrootPackages = {
        aarch64-darwin = with self'; [
          devShells.default.inputDerivation
          packages.darwin-lodurr
          packages.localPackages
        ];
        x86_64-darwin = with self'; [
          devShells.default.inputDerivation
          packages.darwin-kvasir
          packages.localPackages
        ];
        x86_64-linux = with self'; [
          devShells.default.inputDerivation
          packages.localPackages
          packages.nixos-heimdall
        ];
      };
    in {
      packages.gcroot =
        pkgs.linkFarmFromDrvs "dotfiles" gcrootPackages.${system};
    };
}
