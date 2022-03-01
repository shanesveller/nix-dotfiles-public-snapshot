{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.wm.polybar;
in {
  options.programs.shanesveller.wm.polybar = {
    enable = mkEnableOption "polybar";

    package = mkOption {
      type = types.package;
      # https://github.com/NixOS/nixpkgs/blob/a51aa6523bd8ee985bc70987909eff235900197a/pkgs/applications/misc/polybar/default.nix#L34-L41
      default = pkgs.polybar.override {
        alsaSupport = true;
        nlSupport = true;
        pulseSupport = true;
      };
      defaultText = "pkgs.polybar";
      example = literalExample "pkgs.polybar";
      description = "The polybar package to use.";
    };
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      config = {
        "bar/main" = {
          enable-ipc = true;
          font-0 = "FiraCode Nerd Font Mono:size=12:style=Regular;0";
          font-1 = "FiraCode Nerd Font Mono:size=12:style=Light;0";
          font-2 = "FiraCode Nerd Font Mono:size=12:style=Retina;0";
          font-3 = "Noto Emoji:style=Regular;0";
          height = 30;
          locale = "en_US.UTF-8";
          module-margin = 2;
          modules-center = "title";
          modules-left = "bspwm";
          modules-right = "network cpu memory pulseaudio datetime";
          separator = "|";
          throttle-output = 5;
          throttle-output-for = 10;
          tray-padding = 2;
          tray-position = "right";
          width = "100%";
        };

        "module/bspwm" = {
          type = "internal/bspwm";
          pin-workspaces = true;
          inline-mode = false;
          enable-click = true;
          enable-scroll = true;
          reverse-scroll = false;
          ws-icon-0 = "dev;⚙";
          ws-icon-1 = "chat;💬";
          ws-icon-2 = "mail;📨";
          ws-icon-3 = "games;♞";
          ws-icon-4 = "media;𝅘𝅥𝅮";
          ws-icon-5 = "util;🔧";
          ws-icon-6 = "VII;";
          ws-icon-7 = "VIII;";
          ws-icon-8 = "IX;";
          ws-icon-9 = "X;";
          format = "<label-state> <label-mode>";
          label-monitor = "%name%";
          label-mode-padding = "1";
          label-focused = "%icon% %name%";
          label-focused-padding = 1;
          label-occupied = "%icon% %name%";
          label-occupied-padding = 1;
          label-urgent = "%icon% %name%";
          label-urgent-padding = 1;
          label-empty = "%icon% %name%";
          label-empty-padding = 1;
          label-dimmed-foreground = "\${colors.purple}";
          label-dimmed-underline = "\${colors.purple}";
          label-dimmed-focused-background = "\${colors.purple}";
          label-focused-foreground = "\${colors.blue}";
          label-focused-underline = "\${colors.blue}";
          label-occupied-underline = "\${colors.purple}";
          label-urgent-foreground = "\${colors.urgent}";
          label-urgent-underline = "\${colors.urgent}";
          label-monocle = "";
          label-tiled = "";
          label-fullscreen = "";
          label-floating = "";
          label-pseudotiled = "P";
          label-locked = "";
          label-sticky = "";
          label-private = "";
          label-marked = "M";
          label-sticky-foreground = "\${colors.purple}";
          label-locked-foreground = "\${colors.moderate}";
          label-private-foreground = "\${colors.urgent}";
          label-separator = "|";
          label-separator-padding = "2";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
        };

        "module/datetime" = {
          type = "internal/date";
          date = "%m-%d%";
          format = "⏲ <label>";
          interval = "1.0";
          label = "%date% - %time%";
          time = "%H:%M";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 5;
          label = "%gb_used%/%gb_total% (%mb_swap_used%)";
        };

        "module/network" = {
          type = "internal/network";
          accumulate-stats = true;
          interface = "enp5s0";
          label-connected = "%downspeed%/%upspeed%";
          label-disconnected = "DOWN";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          format-volume = "<ramp-volume> <label-volume>";
          interval = 5;
          label-muted = "muted";
          label-muted-foreground = "#666";
          ramp-volume-0 = "🔈";
          ramp-volume-1 = "🔉";
          ramp-volume-2 = "🔊";
        };

        "module/title" = { type = "internal/xwindow"; };
      };
      package = cfg.package;
      script = "polybar main &";
    };
  };
}
