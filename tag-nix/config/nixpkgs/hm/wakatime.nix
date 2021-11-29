{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.wakatime;
in {
  options.programs.shanesveller.wakatime.enable = mkEnableOption "Wakatime";

  # TODO: PGP decrypt config here, not RCM post-hook?
  config = mkIf cfg.enable { home.packages = [ pkgs.wakatime ]; };
}
