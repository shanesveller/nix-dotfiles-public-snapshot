{ config, lib, ... }:

with lib;
let cfg = config.programs.shanesveller.zsh;
in {
  options.programs.shanesveller.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.nix-direnv.enableFlakes = true;
    programs.zsh.enable = true;
  };
}
