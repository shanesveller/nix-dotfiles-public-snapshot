{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.python;
in {
  # TODO: option for package source
  # TODO: option for python 2
  # TODO: option for python 3
  options.programs.shanesveller.python.enable = mkEnableOption "Python";

  config = mkIf cfg.enable {
    # TODO: option for package source
    home.packages = with pkgs; [ pipenv python27Full python37Full ];
  };
}
