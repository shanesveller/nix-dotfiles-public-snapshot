{
  description = "Shane Sveller's Nix/NixOS configurations";

  inputs = {
    cloud-native = {
      url = "github:shanesveller/flake-cloud-native";
      inputs.flake-utils.follows = "flake-utils";
      inputs.master.follows = "nixpkgs-master";
      inputs.nixpkgs.follows = "unstable";
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
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/nixos-21.05";
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "unstable";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "unstable";
    };
    unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, flake-utils-plus, home-manager, nixpkgs, ... }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];

      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = {
          inherit inputs;
          utils = flake-utils-plus;
        };
        modules = [
          { nix.generateRegistryFromInputs = true; }
          {
            # home.stateVersion = "20.09";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          # (import ./modules)
        ];
      };

      sharedOverlays = (with inputs; [
        emacs-overlay.overlay
        flake-utils-plus.outputs.overlay
        rust-overlay.overlay
        self.overlays.my-cloud-native
      ]);

      channelsConfig = {
        allowBroken = false;
        allowUnfree = false;
        allowUnfreePredicate = pkg:
          let
            allowed = builtins.elem name allowedUnfree;
            allowedUnfree = [
              "1password"
              "datagrip"
              "discord"
              "dropbox"
              "firefox-bin"
              "firefox-release-bin-unwrapped"
              "google-chrome"
              "memtest86-efi"
              "nvidia-settings"
              "nvidia-x11"
              "slack"
              "steam"
              "steam-original"
              "steam-runtime"
              # TODO: why-depends on these
              "libspotify"
              "pyspotify"
              "spotify"
              "spotify-unwrapped"
              "vscode"
            ];
            lib = self.inputs.nixpkgs.lib;
            name = lib.getName pkg;
          in lib.traceIf (!allowed) "failed unfree: ${name}" allowed;
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
          ];
      };
      channels.nixpkgs-darwin.input = inputs.nixpkgs-darwin;
      channels.nixpkgs-darwin.overlaysBuilder = _channels:
        with self.overlays; [
          nested-master
          nested-unstable
          unstable-nix-direnv
          unstable-rust-analyzer
        ];
      channels.master.input = inputs.nixpkgs-master;
      channels.unstable.input = inputs.unstable;
      channels.unstable.overlaysBuilder = channels:
        with self.overlays; [
          nested-master
          master-discord
          (_final: _prev: { stable = channels.nixpkgs; })
        ];

      overlays = let
        chooseNewer = left: right:
          if (builtins.compareVersions left.version right.version) > 0 then
            left
          else
            right;
        fromNestedIfNewer = nested_key: name:
          (final: prev:
            builtins.listToAttrs [{
              inherit name;
              value = chooseNewer (builtins.getAttr name prev)
                (builtins.getAttr name prev.${nested_key});
            }]);
        fromMasterIfNewer = fromNestedIfNewer "master";
        fromUnstableIfNewer = fromNestedIfNewer "unstable";
      in {
        master-discord = fromMasterIfNewer "discord";

        my-cloud-native = final: prev: {
          inherit (inputs.cloud-native.legacyPackages.${prev.system})
            flux2 tanka;
        };

        nested-master = final: prev: {
          master = self.pkgs.${prev.system}.master;
        };

        nested-unstable = final: prev: {
          unstable = self.pkgs.${prev.system}.unstable;
        };

        unstable-1password = final: prev: {
          inherit (prev.unstable) _1password;
          # https://github.com/NixOS/nixpkgs/commit/c7fd252d324f6eb4eeb9a769d1533cb4ede361ad
          _1password-gui = prev._1password-gui.overrideAttrs (orig: {
            version = "8.3.0";
            sha256 = "1cakv316ipwyw6s3x4a6qhl0nmg17bxhh08c969gma3svamh1grw";
          });
        };

        unstable-datagrip = fromUnstableIfNewer "datagrip";

        unstable-discord = fromUnstableIfNewer "discord";

        unstable-nix-direnv = fromUnstableIfNewer "nix-direnv";

        unstable-polybar = fromUnstableIfNewer "polybar";

        unstable-rust-analyzer = fromUnstableIfNewer "rust-analyzer";

        unstable-tailscale = fromUnstableIfNewer "tailscale";

        unstable-thunderbird = fromUnstableIfNewer "thunderbird";
      };

      hosts = {
        heimdall = {
          extraArgs = { flake = self; };
          modules = [
            ({ pkgs, ... }: { })
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            ./nixos/machines/heimdall
          ];
        };

        kvasir = {
          builder = inputs.darwin.lib.darwinSystem;
          output = "darwinConfigurations";

          system = "x86_64-darwin";
          channelName = "nixpkgs-darwin";
          extraArgs = { inherit (inputs) darwin; };
          modules = [
            home-manager.darwinModules.home-manager
            ./host-Kvasir.local/config/nixpkgs/darwin/configuration.nix
          ];
        };

        skadi = {
          builder = inputs.darwin.lib.darwinSystem;
          output = "darwinConfigurations";

          system = "x86_64-darwin";
          channelName = "nixpkgs-darwin";
          extraArgs = { inherit (inputs) darwin; };
          modules = [
            home-manager.darwinModules.home-manager
            ./host-skadi/config/nixpkgs/darwin/configuration.nix
          ];
        };

        yggdrasil = {
          extraArgs = {
            inherit inputs;
            flake = self;
          };
          modules = [
            ({ ... }: { nixpkgs.overlays = builtins.attrValues self.overlays; })
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            ./nixos/machines/yggdrasil
          ];
        };
      };

      homeConfigurations = {
        x86_64-darwin = let
          # Unstable required for Darwin on Big Sur
          pkgs = self.pkgs."${system}".nixpkgs-darwin;
          system = "x86_64-darwin";
        in {
          kvasir = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;

            configuration = { ... }: {
              imports = [
                ./tag-nix/config/nixpkgs/home.nix
                ./host-Kvasir.local/config/nixpkgs/host.nix
              ];
            };

            # unstable only
            extraModules = [ ./tag-nix/config/nixpkgs/hm/modules.nix ];
            extraSpecialArgs = {
              inherit pkgs;
              flake = self;
            };
            homeDirectory = "/Users/shane";
            username = "shane";
          };

          skadi = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;

            configuration = { ... }: {
              imports = [
                ./tag-nix/config/nixpkgs/home.nix
                ./host-skadi/config/nixpkgs/host.nix
              ];
            };

            # unstable only
            extraModules = [ ./tag-nix/config/nixpkgs/hm/modules.nix ];
            extraSpecialArgs = {
              inherit pkgs;
              flake = self;
            };
            homeDirectory = "/Users/shanesveller";
            username = "shanesveller";
          };
        };

        x86_64-linux = let
          pkgs = self.pkgs."${system}".nixpkgs;
          system = "x86_64-linux";
        in {
          heimdall = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;

            configuration = { ... }: {
              imports = [
                ./tag-nix/config/nixpkgs/home.nix
                # ./tag-nix/config/nixpkgs/hm/modules.nix
                ./host-heimdall/config/nixpkgs/host.nix
              ];
            };

            # unstable only
            extraModules = [ ./tag-nix/config/nixpkgs/hm/modules.nix ];
            extraSpecialArgs = {
              inherit pkgs;
              flake = self;
            };
            homeDirectory = "/home/shane";
            username = "shane";
          };

          yggdrasil = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system;

            configuration = { ... }: {
              imports = [
                ./tag-nix/config/nixpkgs/home.nix
                ./host-yggdrasil/config/nixpkgs/host.nix
              ];
            };

            # unstable only
            extraModules = [ ./tag-nix/config/nixpkgs/hm/modules.nix ];
            extraSpecialArgs = {
              inherit pkgs;
              flake = self;
            };
            homeDirectory = "/home/shane";
            username = "shane";
          };
        };
      };

      outputsBuilder = channels:
        let
          system = channels.nixpkgs.system;
          nixpkgs = if system == "x86-64-linux" then
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
            shared = {
              nix-wrapper = pkgs.writeShellScriptBin "nix" ''
                ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
              '';
            };
            system_pkgs = if system == "x86_64-linux" then {
              emacs = pkgs.unstable.emacsPgtkGcc;
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
              darwin-skadi =
                self.outputs.darwinConfigurations.skadi.config.system.build.toplevel;
              emacs = pkgs.unstable.emacsGcc;
              gcroot-kvasir = mkGcRoot "kvasir";
              gcroot-skadi = mkGcRoot "skadi";
              home-kvasir =
                self.outputs.homeConfigurations."${system}".kvasir.activationPackage;
              home-skadi =
                self.outputs.homeConfigurations."${system}".skadi.activationPackage;
            };
            # TODO: Research why mkMerge/mkIf is not viable here
          in pkgs.lib.trivial.mergeAttrs shared system_pkgs;

          devShell = nixpkgs.mkShell {
            name = "devShell";

            buildInputs = with pkgs;
              [
                fup-repl
                (import home-manager { inherit pkgs; }).home-manager
                neovim
                rcm
                ripgrep
                watchexec
              ] ++ (with self.outputs.packages.${system}; [ nix-wrapper ]);

            NIX_PATH = "nixpkgs=${inputs.nixpkgs}:unstable=${inputs.unstable}";
            RCRC = toString ./rcrc;

            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        };

      checks.x86_64-darwin.pre-commit-check =
        inputs.pre-commit.lib.x86_64-darwin.run {
          src = ./.;
          hooks = {
            nix-linter.enable = true;
            nixfmt.enable = true;
            shellcheck.enable = true;
          };
          # settings = {
          #   nix-linter.checks = [ "AlphabeticalArgs" ];
          # };
        };

      checks.x86_64-linux.pre-commit-check =
        inputs.pre-commit.lib.x86_64-linux.run {
          src = ./.;
          hooks = {
            nix-linter.enable = true;
            nixfmt.enable = true;
          };
        };
    };
}
