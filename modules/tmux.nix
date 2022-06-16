{ config, lib, pkgs, ... }:

with pkgs;
with lib;
let
  cfg = config.programs.shanesveller.tmux;
  tmuxpFiles = let
    customSessions = { };
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
    personalSessions = attrsets.mapAttrs editorSession cfg.personalProjects;
    workSessions = attrsets.mapAttrs editorSession cfg.workProjects;
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
  options.programs.shanesveller.tmux = {
    enable = mkEnableOption "Tmux";
    emacs = mkEnableOption "Use Emacs for EDITOR";
    personalProjects = mkOption {
      type = types.attrsOf types.str;
      default = {
        "blog" = "~/src/shanesveller-dot-com";
        "dotfiles" = "~/.dotfiles";
        "helm" = "~/src/infra/helm-charts";
        "org" = "~/Dropbox/org";
        "rampart" = "~/src/side-projects/games/rampart";
      };
      example = { "dotfiles" = "$HOME/.dotfiles"; };
      description = "Attrset of names and paths for tmuxp projects";
    };

    workProjects = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = { "monorepo" = "$HOME/src/monorepo"; };
      description = "Attrset of names and paths for tmuxp projects";
    };
  };

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
