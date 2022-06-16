{ inputs, lib, self, withSystem, ... }: {
  flake = {
    nixosConfigurations = withSystem "x86_64-linux" ({ pkgs, system, ... }:
      let
        mkNixOs = machineConfig:
          lib.nixosSystem {
            inherit pkgs system;

            modules = [
              {
                config._module.args = {
                  inherit inputs;
                  flake = self;
                };
              }
              inputs.nixpkgs.nixosModules.notDetected
              inputs.agenix.nixosModules.age
              inputs.home-manager.nixosModules.home-manager
              machineConfig
            ];
          };
      in {
        heimdall = mkNixOs ../nixos/machines/heimdall;
        yggdrasil = mkNixOs ../nixos/machines/yggdrasil;
      });

    packages.x86_64-linux = lib.attrsets.mapAttrs' (name: value:
      lib.attrsets.nameValuePair "nixos-${name}"
      value.config.system.build.toplevel) self.outputs.nixosConfigurations;
  };
}
