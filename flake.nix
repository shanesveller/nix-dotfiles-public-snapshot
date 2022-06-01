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
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-21.11";
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "unstable";
    };
    unstable.url = "nixpkgs/nixos-unstable";
  };

  nixConfig = {
    extra-substituters = [ "https://shanesveller.cachix.org" ];
    extra-trusted-public-keys = [
      "shanesveller.cachix.org-1:SzmUXrd5XqRW5dQzm2dT6CJjT7/iudnoLzOAHj8hK6o="
    ];
  };

  outputs = inputs@{ self, flake-utils-plus, home-manager, nixpkgs, ... }:
    let supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];
    in flake-utils-plus.lib.mkFlake {
      inherit inputs self supportedSystems;

      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = { inherit inputs; };
        modules = [
          { nix.generateRegistryFromInputs = true; }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      sharedOverlays = (with inputs; [
        emacs-overlay.overlay
        flake-utils-plus.outputs.overlay
      ]);

      channelsConfig = {
        allowBroken = false;
        allowUnfree = false;
        allowUnfreePredicate =
          import ./nix/unfree.nix { lib = inputs.nixpkgs.lib; };
      };

      channels.nixpkgs = {
        input = nixpkgs;

        overlaysBuilder = _channels:
          with self.overlays; [
            nested-master
            nested-unstable
            master-discord
            unstable-1password
            unstable-datagrip
            unstable-nix-direnv
            unstable-polybar
            unstable-rust-analyzer
            unstable-tailscale
            unstable-thunderbird
            self.overlay
            my-zellij
          ];
      };
      channels.nixpkgs-darwin.input = inputs.nixpkgs-darwin;
      channels.nixpkgs-darwin.overlaysBuilder = _channels:
        with self.overlays; [
          nested-master
          nested-unstable
          unstable-nix-direnv
          unstable-rust-analyzer
          self.overlay
          my-zellij
        ];
      channels.master.input = inputs.nixpkgs-master;
      channels.unstable.input = inputs.unstable;
      channels.unstable.overlaysBuilder = channels:
        with self.overlays; [
          nested-master
          master-discord
          (_final: _prev: { stable = channels.nixpkgs; })
        ];

      overlays = import ./nix/overlays.nix self;

      hosts = let
        mkDarwin = machineConfig: {
          builder = inputs.darwin.lib.darwinSystem;
          channelName = "nixpkgs-darwin";
          extraArgs = {
            inherit (inputs) darwin;
            inherit inputs;
            flake = self;
          };
          modules = [ home-manager.darwinModules.home-manager machineConfig ];
          output = "darwinConfigurations";
          system = "x86_64-darwin";
        };
        mkNixOs = machineConfig: {
          extraArgs = {
            inherit inputs;
            flake = self;
          };
          modules = [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.age
            machineConfig
          ];
        };
      in {
        heimdall = mkNixOs ./nixos/machines/heimdall;
        kvasir = mkDarwin ./machines/kvasir/darwin.nix;
        yggdrasil = mkNixOs ./nixos/machines/yggdrasil;
      };

      homeConfigurations = let
        mkHome = { homeDirectory, machineConfig, pkgs, system, username, }:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit homeDirectory pkgs system username;

            configuration = { ... }: {
              imports = [ ./modules/nix.nix machineConfig ];
            };

            extraModules = [ ./modules/modules.nix ];
            extraSpecialArgs = {
              inherit pkgs;
              flake = self;
            };
          };
      in {
        x86_64-darwin = let
          # Unstable required for Darwin on Big Sur
          pkgs = self.pkgs."${system}".nixpkgs-darwin;
          system = "x86_64-darwin";
        in {
          kvasir = mkHome {
            inherit pkgs system;
            homeDirectory = "/Users/shane";
            machineConfig = ./machines/kvasir/home.nix;
            username = "shane";
          };
        };

        x86_64-linux = let
          homeDirectory = "/home/shane";
          pkgs = self.pkgs."${system}".nixpkgs;
          system = "x86_64-linux";
          username = "shane";
        in {
          heimdall = mkHome {
            inherit homeDirectory pkgs system username;
            machineConfig = ./machines/heimdall/home.nix;
          };

          yggdrasil = mkHome {
            inherit homeDirectory pkgs system username;
            machineConfig = ./machines/yggdrasil/home.nix;
          };
        };
      };

      outputsBuilder = channels:
        let
          system = channels.nixpkgs.system;
          nixpkgs = if system == "x86_64-linux" then
            channels.nixpkgs
          else
            channels.nixpkgs-darwin;
          pkgs = nixpkgs.pkgs;
        in {
          packages = let
            mkGcRoot = systemName:
              self.pkgs."${system}".nixpkgs.linkFarmFromDrvs "dotfiles"
              (with self.outputs; [
                devShell."${system}".inputDerivation
                packages."${system}"."darwin-${systemName}"
                packages."${system}"."home-${systemName}"
              ]);
            shared = let
              callRustPackage = path:
                pkgs.callPackage path {
                  inherit (pkgs.unstable.rustPlatform) buildRustPackage;
                };
            in {
              bacon = callRustPackage ./pkgs/bacon.nix;
              cargo-hack = callRustPackage ./pkgs/cargo-hack.nix;
              cargo-nextest = callRustPackage ./pkgs/cargo-nextest.nix;
              jless = callRustPackage ./pkgs/jless.nix;
              zellij = pkgs.callPackage ./pkgs/zellij.nix {
                inherit (pkgs.darwin.apple_sdk.frameworks)
                  DiskArbitration Foundation;
              };

              localPackages =
                self.pkgs."${system}".nixpkgs.linkFarmFromDrvs "localPackages"
                (with self.outputs.packages."${system}"; [
                  bacon
                  cargo-hack
                  cargo-nextest
                  emacs
                  jless
                  zellij
                ]);

              nix-wrapper = pkgs.writeShellScriptBin "nix" ''
                ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
              '';
            };
            system_pkgs = if system == "x86_64-linux" then {
              emacs = pkgs.emacsPgtkNativeComp;
              gcroot = self.pkgs."${system}".nixpkgs.linkFarmFromDrvs "dotfiles"
                (with self.outputs; [
                  devShell."${system}".inputDerivation
                  packages."${system}".home-heimdall
                  nixosConfigurations.heimdall.config.system.build.toplevel
                ]);
              home-heimdall =
                self.outputs.homeConfigurations."${system}".heimdall.activationPackage;

              home-yggdrasil =
                self.outputs.homeConfigurations."${system}".yggdrasil.activationPackage;

              nixos-heimdall =
                self.outputs.nixosConfigurations.heimdall.config.system.build.toplevel;

              nixos-yggdrasil =
                self.outputs.nixosConfigurations.yggdrasil.config.system.build.toplevel;
            } else {
              darwin-kvasir =
                self.outputs.darwinConfigurations.kvasir.config.system.build.toplevel;
              emacs = pkgs.emacsNativeComp;
              gcroot-kvasir = mkGcRoot "kvasir";
              home-kvasir =
                self.outputs.homeConfigurations."${system}".kvasir.activationPackage;
            };
            # TODO: Research why mkMerge/mkIf is not viable here
          in pkgs.lib.trivial.mergeAttrs shared system_pkgs;

          # TODO: Can be dropped on Nix 2.7+ or so
          devShell = self.outputs.devShells.${system}.default;
          devShells = let
            basePkgs = [ self.outputs.packages.${system}.nix-wrapper ];
            NIX_PATH = "nixpkgs=${inputs.nixpkgs}:unstable=${inputs.unstable}";
          in {
            default = nixpkgs.mkShell {
              name = "devShell";
              buildInputs = with pkgs; [ just neovim ] ++ basePkgs;

              inherit NIX_PATH;
              inherit (self.checks.${system}.pre-commit-check) shellHook;
            };

            emacs = nixpkgs.mkShell {
              name = "dotfiles-emacs";
              buildInputs = [ pkgs.emacs ] ++ basePkgs;

              inherit NIX_PATH;
            };
          };
        };

      checks = let
        mkChecks = system:
          import ./nix/checks.nix {
            inherit (inputs) pre-commit;
            inherit system;
          };
      in nixpkgs.lib.attrsets.genAttrs supportedSystems
      (system: { pre-commit-check = mkChecks system; });

      overlay = (import ./nix/overlay.nix) self;
    };
}
