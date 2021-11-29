{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.work;
in {
  options.programs.shanesveller.work.enable = mkEnableOption "Work";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ aws-iam-authenticator aws-vault awscli2 ];
  };
}
