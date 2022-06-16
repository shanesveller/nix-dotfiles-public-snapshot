{ inputs, self, withSystem, ... }: {
  flake = let
    mkHome = { homeDirectory, machineConfig, pkgs, system, username, }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit homeDirectory pkgs system username;

        configuration = _inputs: {
          imports = [ ../modules/nix.nix machineConfig ];
        };

        extraModules = [ ../modules/modules.nix ];
        extraSpecialArgs = {
          inherit pkgs;
          flake = self;
        };
      };
  in {
    homeConfigurations = {
      aarch64-darwin = withSystem "aarch64-darwin" (ctx@{ pkgs, system, ... }: {
        lodurr = mkHome {
          inherit pkgs system;

          machineConfig = ../machines/lodurr/home.nix;
          homeDirectory = "/Users/shanesveller";
          username = "shanesveller";
        };
      });

      x86_64-darwin = withSystem "x86_64-darwin" (ctx@{ pkgs, system, ... }: {
        kvasir = mkHome {
          inherit pkgs system;
          homeDirectory = "/Users/shane";
          machineConfig = ../machines/kvasir/home.nix;
          username = "shane";
        };
      });

      x86_64-linux = withSystem "x86_64-linux" (ctx@{ pkgs, system, ... }:
        let
          homeDirectory = "/home/shane";
          username = "shane";
        in {
          heimdall = mkHome {
            inherit homeDirectory pkgs system username;
            machineConfig = ../machines/heimdall/home.nix;
          };
          yggdrasil = mkHome {
            inherit homeDirectory pkgs system username;
            machineConfig = ../machines/yggdrasil/home.nix;
          };
        });
    };

    # packages = let
    #   mapHomeConfigs = configName: homeConfig:
    #     lib.attrsets.nameValuePair "home-${configName}"
    #     homeConfig.activationPackage;
    #   mapSystems = _system: homeConfigs:
    #     lib.attrsets.mapAttrs' (lib.debug.traceVal homeConfigs);
    # in lib.debug.traceValSeq (builtins.mapAttrs mapSystems homeConfigurations);
    #
    packages.aarch64-darwin.home-lodurr =
      self.outputs.homeConfigurations.aarch64-darwin.lodurr.activationPackage;
    packages.x86_64-darwin.home-kvasir =
      self.outputs.homeConfigurations.x86_64-darwin.kvasir.activationPackage;
    packages.x86_64-linux = with self.outputs.homeConfigurations.x86_64-linux; {
      home-heimdall = heimdall.activationPackage;
      home-yggdrasil = yggdrasil.activationPackage;
    };
  };
}
