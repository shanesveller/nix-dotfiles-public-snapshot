{ config, inputs, lib, self, ... }: {
  perSystem = { config, pkgs, system, ... }: {
    devShells = let
      basePkgs = [ config.packages.nix-wrapper ];
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}:unstable=${inputs.unstable}";
    in {
      default = pkgs.mkShell {
        name = "devShell";
        buildInputs = with pkgs; [ just neovim ] ++ basePkgs;

        inherit NIX_PATH;
        inherit (config.checks.pre-commit-check) shellHook;
      };

      emacs = pkgs.mkShell {
        name = "dotfiles-emacs";
        buildInputs = [ pkgs.emacs ] ++ basePkgs;

        inherit NIX_PATH;
      };
    };
  };

  # TODO: Why doesn't this work inside perSystem
  flake = {
    devShell = lib.attrsets.genAttrs config.systems
      (system: self.outputs.devShells.${system}.default);
  };
}
