{ inputs, self, withSystem, ... }: {
  flake = {
    darwinConfigurations = let
      mkDarwin = system: machineConfig:
        withSystem system ({ pkgs, ... }:
          inputs.darwin.lib.darwinSystem {
            inherit pkgs system;
            inputs = { inherit (inputs) darwin; };
            modules =
              [ inputs.home-manager.darwinModules.home-manager machineConfig ];
          });
      mkDarwinArm = mkDarwin "aarch64-darwin";
      mkDarwinIntel = mkDarwin "x86_64-darwin";
    in {
      lodurr = mkDarwinArm ../machines/lodurr/darwin.nix;
      kvasir = mkDarwinIntel ../machines/kvasir/darwin.nix;
    };

    packages = with self.outputs.darwinConfigurations; {
      aarch64-darwin.darwin-lodurr = lodurr.config.system.build.toplevel;
      x86_64-darwin.darwin-kvasir = kvasir.config.system.build.toplevel;
    };
  };
}
