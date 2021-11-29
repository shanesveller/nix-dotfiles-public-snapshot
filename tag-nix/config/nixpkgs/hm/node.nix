{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.node;

  preferred_node = pkgs.unstable.nodejs;

  # TODO: option for overlay, or extract overlay
  # TODO: option for package source
  npm = pkgs.unstable.nodePackages.npm;
  yarn = pkgs.unstable.nodePackages.yarn;
in {
  # TODO: option for package source
  options.programs.shanesveller.node.enable = mkEnableOption "Node.js";

  config = mkIf cfg.enable { home.packages = [ npm preferred_node yarn ]; };
}
