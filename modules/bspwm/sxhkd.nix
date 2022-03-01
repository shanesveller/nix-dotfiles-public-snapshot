{ config, lib, pkgs, ... }:

with lib;
let
  bspwm_cfg = config.programs.shanesveller.wm.bspwm;
  cfg = config.programs.shanesveller.wm.sxhkd;
in {
  options.programs.shanesveller.wm.sxhkd = {
    enable = mkEnableOption "sxhkd";

    package = mkOption {
      type = types.package;
      default = pkgs.sxhkd;
      defaultText = "pkgs.sxhkd";
      example = literalExample "pkgs.sxhkd";
      description = "The sxhkd package to use.";
    };
  };
  config = mkIf cfg.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        ### WM agnostic
        # reload
        "super + Escape" = "pkill -USR1 -x sxhkd";
        # terminal
        "super + Return" = "${pkgs.alacritty}/bin/alacritty";
        # launcher
        "super + @space" = "${pkgs.rofi}/bin/rofi -show run";

        ### bspwm
        # quit/reload
        "super + alt + {q,r}" = "${bspwm_cfg.package}/bin/bspc {quit,wm -r}";
        # close/kill
        "super + {_,shift + }w" = "${bspwm_cfg.package}/bin/bspc node -{c,k}";
        # lock screen
        "super + shift + l" = "${pkgs.systemd}/bin/loginctl lock-session";

        # alternate between the tiled and monocle layout
        "super + m" = "${bspwm_cfg.package}/bin/bspc desktop -l next";
        # send the newest marked node to the newest preselected node
        "super + y" =
          "${bspwm_cfg.package}/bin/bspc node newest.marked.local -n newest.!automatic.local";
        # swap the current node and the biggest window
        "super + g" = "${bspwm_cfg.package}/bin/bspc node -s biggest.window";

        # state/flags
        # set the window state
        "super + {t,shift + t,s,f}" =
          "${bspwm_cfg.package}/bin/bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        # set the node flags
        "super + ctrl + {m,x,y,z}" =
          "${bspwm_cfg.package}/bin/bspc node -g {marked,locked,sticky,private}";

        # focus/swap
        # focus the node in the given direction
        "super + {_,shift + }{h,j,k,l}" =
          "${bspwm_cfg.package}/bin/bspc node -{f,s} {west,south,north,east}";
        # focus the node for the given path jump
        "super + {p,b,comma,period}" =
          "${bspwm_cfg.package}/bin/bspc node -f @{parent,brother,first,second}";

        # focus the next/previous window in the current desktop
        "super + {_,shift + }c" =
          "${bspwm_cfg.package}/bin/bspc node -f {next,prev}.local.!hidden.window";

        # focus the next/previous desktop in the current monitor
        "super + bracket{left,right}" =
          "${bspwm_cfg.package}/bin/bspc desktop -f {prev,next}.local";

        # focus the last node/desktop
        "super + {grave,Tab}" =
          "${bspwm_cfg.package}/bin/bspc {node,desktop} -f last";

        # focus the older or newer node in the focus history
        "super + {o,i}" = builtins.replaceStrings [ "\n" ] [ "" ] ''
          ${bspwm_cfg.package}/bin/bspc wm -h off; \
          ${bspwm_cfg.package}/bin/bspc node {older,newer} -f; \
          ${bspwm_cfg.package}/bin/bspc wm -h on
        '';

        # focus or send to the given desktop
        "super + {_,shift + }{1-9,0}" =
          "${bspwm_cfg.package}/bin/bspc {desktop -f,node -d} '^{1-9,10}'";

        # preselect
        # preselect the direction
        "super + ctrl + {h,j,k,l}" =
          "${bspwm_cfg.package}/bin/bspc node -p {west,south,north,east}";

        # preselect the ratio
        "super + ctrl + {1-9}" =
          "${bspwm_cfg.package}/bin/bspc node -o 0.{1-9}";

        # cancel the preselection for the focused node
        "super + ctrl + space" = "${bspwm_cfg.package}/bin/bspc node -p cancel";

        # cancel the preselection for the focused desktop
        "super + ctrl + shift + space" =
          "${bspwm_cfg.package}/bin/bspc query -N -d | xargs -I id -n 1 ${cfg.package}/bin/bspc node id -p cancel";

        # move/resize
        # expand a window by moving one of its side outward
        "super + alt + {h,j,k,l}" =
          "${bspwm_cfg.package}/bin/bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

        # contract a window by moving one of its side inward
        "super + alt + shift + {h,j,k,l}" =
          "${bspwm_cfg.package}/bin/bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

        # move a floating window
        "super + {Left,Down,Up,Right}" =
          "${bspwm_cfg.package}/bin/bspc node -v {-20 0,0 20,0 -20,20 0}";
      };
    };

    xsession.profileExtra = "export SXKHD_SHELL=sh";
  };
}
