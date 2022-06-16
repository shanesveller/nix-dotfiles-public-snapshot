_inputs: {
  perSystem = { pkgs, system, ... }:
    let
      emacsPackages = {
        aarch64-darwin = pkgs.emacsNativeComp;
        x86_64-darwin = pkgs.emacsNativeComp;
        x86_64-linux = pkgs.emacsPgtkNativeComp;
      };
    in { packages.emacs = emacsPackages.${system}; };
}
