{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.wm.bspwm;
in {
  imports = if pkgs.stdenv.isLinux then [ ./polybar.nix ./sxhkd.nix ] else [ ];

  options.programs.shanesveller.wm.bspwm = {
    enable = mkEnableOption "bspwm";

    package = mkOption {
      type = types.package;
      default = pkgs.bspwm;
      defaultText = "pkgs.bspwm";
      example = literalExample "pkgs.bspwm";
      description = "The bspwm package to use.";
    };
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    xsession.enable = true;
    xsession.initExtra = "";
    xsession.profileExtra = "";
    # master branch
    # xsession.profilePath = ".xprofile-hm";
    xsession.scriptPath = ".xsession-hm";

    xsession.numlock.enable = false;
    xsession.preferStatusNotifierItems = true;

    # xsession.windowManager.command = "bspwm";
    xsession.windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        bspc subscribe all > $HOME/.bspwm.log &
      '';
      monitors = {
        # xrandr -q to identify monitor/port
        DisplayPort-1 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ];
      };
      rules = { };
      settings = {
        border_width = 2;
        borderless_monocle = true;
        gapless_monocle = true;
        split_ratio = 0.5;
        window_gap = 12;
      };
      startupPrograms = [ "dropbox start" ];
    };
  };

}
