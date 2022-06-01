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
    xsession.profileExtra = "export _JAVA_AWT_WM_NONREPARENTING=1";
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
        DisplayPort-1 =
          [ "dev" "chat" "mail" "games" "media" "util" "VII" "VIII" "IX" "X" ];
      };
      # xprop | grep WM_CLASS
      rules = {
        "Alacritty" = { desktop = "dev"; };
        "Aseprite" = { desktop = "media"; };
        "Code" = { desktop = "dev"; };
        "discord" = { desktop = "chat"; };
        # Firefox
        "Navigator" = { desktop = "dev"; };
        "jetbrains-datagrip" = { desktop = "util"; };
        "PolyMC" = { desktop = "games"; };
        "rampart" = { state = "floating"; };
        "Seahorse" = { desktop = "mail"; };
        "Slack" = { desktop = "chat"; };
        "Steam" = { desktop = "games"; };
        "Thunderbird" = { desktop = "mail"; };
      };
      settings = {
        border_width = 2;
        borderless_monocle = true;
        gapless_monocle = true;
        split_ratio = 0.5;
        window_gap = 12;
      };
      startupPrograms = [
        "dropbox start"
        "seahorse"
        "alacritty"
        "firefox"
        "discord"
        "slack"
        "thunderbird"
      ];
    };
  };

}
