{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.lisp;
in {
  options.programs.shanesveller.lisp.enable = mkEnableOption "Lisp";

  config =
    mkIf cfg.enable { home.packages = with pkgs; [ guile racket-minimal ]; };
}
