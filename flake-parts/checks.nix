{ inputs, ... }: {
  perSystem = { config, pkgs, system, ... }: {
    checks = {
      inherit (config.packages) localPackages;

      pre-commit-check = inputs.pre-commit.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
          shellcheck.enable = true;
        };
      };
    };
  };
}
