{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.local;

  hostess = pkgs.callPackage ../pkgs/hostess { };
in {
  options.programs.shanesveller.local.enable = mkEnableOption "Local packages";
  options.programs.shanesveller.local.home =
    mkEnableOption "Home-specific local packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; lib.optionals (cfg.home) [ hostess ];
  };
}
