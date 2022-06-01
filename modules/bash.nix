{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.bash;
in {
  options.programs.shanesveller.bash.enable = mkEnableOption "Bash";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.bashInteractive ];

    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.nix-direnv.enableFlakes = true;
    programs.bash.enable = true;
  };
}
