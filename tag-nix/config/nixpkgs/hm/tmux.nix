{ config, lib, pkgs, ... }:

with pkgs;
with lib;
let
  cfg = config.programs.shanesveller.tmux;
  tmuxpFiles = let
    personalProjects = {
      "advent" = "~/src/advent/rust/advent-2019";
      "beer" = "~/src/side-projects/beer-share/backend";
      "blog" = "~/src/shanesveller-dot-com";
      "cellar" = "~/src/side-projects/beer-share/backend";
      "doom" = "~/.emacs.d";
      "dotfiles" = "~/.dotfiles";
      "emacs" = "~/src/emacs-distribution";
      "exercism" = "~/src/exercism";
      "geek-api" = "~/src/side-projects/fantasy-geek/api-rs";
      "geek-client" = "~/src/side-projects/fantasy-geek/client";
      "geek-data" = "~/src/side-projects/fantasy-geek/data";
      "gitlab" = "~/src/infra/gitlab";
      "helm" = "~/src/infra/helm-charts";
      "officer" = "~/src/side-projects/kubernetes-operators/officer";
      "org" = "~/Dropbox/org";
      "playground" = "~/src/rust/playground";
      "realm" = "~/src/side-projects/mud/realmatic_theory";
      "tf" = "~/src/infra/terraform";
      "tabletop" = "~/src/side-projects/tabletop/backend";
    };
    workProjects = { "fros" = "~/src/fastradius/fast-radius"; };
    customSessions = {
      "jaeger" = commandSession "jaeger" ''
        docker run -it --rm --name jaeger \
                    -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
                    -p 5775:5775/udp \
                    -p 6831:6831/udp \
                    -p 6832:6832/udp \
                    -p 5778:5778 \
                    -p 16686:16686 \
                    -p 14268:14268 \
                    -p 9411:9411 \
                    jaegertracing/all-in-one:1.13
      '' {
        shell_command_before =
          [ "docker ps -q >/dev/null" "docker rm -f jaeger" ];
      };

      "music" = commandSession "music" "pianobar" { };

      "plantuml" = commandSession "plantuml"
        "docker run -it --name plantuml --rm -p 8080:8080 plantuml/plantuml-server:jetty" {
          shell_command_before =
            [ "docker ps -q >/dev/null" "docker rm -f plantuml" ];
        };
    };
    # TODO: cross-module config lookup
    editorCommand = if cfg.emacs then "et ." else "$EDITOR .";
    tmuxpPane = shell_command: focus: rest:
      {
        inherit focus shell_command;
      } // rest;
    commandsSession = window_name: commands: rest:
      {
        session_name = window_name;
        windows = [{
          inherit window_name;
          layout = "even-horizontal";
          panes = map (cmd: (tmuxpPane cmd false { })) commands;
        }];
      } // rest;
    commandSession = name: command: commandsSession name [ command ];
    editorSession = name: start_directory:
      (commandSession name editorCommand { inherit start_directory; });
    yamlText = generators.toYAML { };
    yamlFileForSession = name: session:
      pkgs.writeTextDir ".tmuxp/${name}.yaml" (yamlText session);
    personalSessions = attrsets.mapAttrs editorSession personalProjects;
    workSessions = attrsets.mapAttrs editorSession workProjects;
    sessions = builtins.foldl' lib.trivial.mergeAttrs { } [
      personalSessions
      workSessions
      customSessions
    ];
    sessionFiles = attrsets.mapAttrsToList yamlFileForSession sessions;
  in symlinkJoin {
    name = "tmuxp-profiles";
    paths = sessionFiles;
  };
in {
  options.programs.shanesveller.tmux.enable = mkEnableOption "Tmux";
  options.programs.shanesveller.tmux.emacs =
    mkEnableOption "Use Emacs for EDITOR";

  config = mkIf cfg.enable {
    home.file.".tmuxp".source = "${tmuxpFiles}/.tmuxp";
    home.packages = optionals (stdenv.isDarwin) [ reattach-to-user-namespace ];
    programs.tmux = {
      enable = true;

      aggressiveResize = !stdenv.isDarwin;
      baseIndex = 1;
      # TODO: This is probably way too high!
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      newSession = true;
      resizeAmount = 10;
      secureSocket = stdenv.isLinux;
      shortcut = "a";
      terminal = "screen-256color";

      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/tmux-plugins/default.nix
      plugins = with tmuxPlugins; [
        ({
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        })
        copycat
        logging
        open
        pain-control
        prefix-highlight
        resurrect
        sensible
        sessionist
        urlview
        yank
        ({
          plugin = power-theme;
          extraConfig = ''
            set-option -g @tmux_power_theme 'snow'
            # 'L' for left only, 'R' for right only and 'LR' for both
            set-option -g @tmux_power_prefix_highlight_pos 'LR'
          '';
        })
      ];

      tmuxinator.enable = true;
      tmuxp.enable = true;

      extraConfig = mkMerge [''
        set-window-option -g main-pane-width 180
      ''];
    };
  };
}
