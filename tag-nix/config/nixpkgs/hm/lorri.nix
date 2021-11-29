{ config, lib, pkgs, ... }:

let cfg = config.programs.shanesveller.lorri;
in with lib; {
  options.programs.shanesveller.lorri.enable = mkEnableOption "Lorri";

  config = mkIf cfg.enable { home.packages = [ pkgs.lorri ]; };
}
