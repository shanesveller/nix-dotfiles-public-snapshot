{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.emacs;
in {
  options.programs.shanesveller.emacs = {
    doom = mkEnableOption "Doom Emacs";
    enable = mkEnableOption "Emacs";
    latex = mkEnableOption "LaTeX";
    pdf = mkEnableOption "PDF support";
    vterm = mkEnableOption "vterm support";

    package = mkOption {
      type = types.package;
      default = pkgs.emacs27;
      defaultText = "pkgs.emacs27";
      example = literalExample "pkgs.emacs27-nox";
      description = "The Emacs package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ coreutils ] ++ (lib.optionals (cfg.doom) [
        cmake
        emacs-all-the-icons-fonts
        gnuplot
        graphviz
        html-tidy
        rnix-lsp
        sqlite
      ]);

    home.sessionVariables = mkMerge [
      { EDITOR = "emacsclient -t -a ''"; }
      (mkIf cfg.doom {
        DOOMDIR = toString "${config.xdg.configHome}/doom";
        # PATH = [ "$XDG_CONFIG_HOME/emacs/bin" "$PATH" ];
      })
    ];

    programs.emacs = {
      enable = true;
      package = cfg.package;
      extraPackages = epkgs:
        ([ ] ++ (lib.optional cfg.pdf epkgs.pdf-tools)
          ++ (lib.optional cfg.vterm epks.vterm));
    };

    programs.texlive.enable = cfg.latex;

    # services.emacs.enable = pkgs.stdenv.isLinux;
    # services.emacs.install = pkgs.stdenv.isLinux;
    # services.emacs.package = cfg.package;

    xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/config/doom";
  };
}
