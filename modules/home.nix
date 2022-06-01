{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.home;
  browser = [ "firefox.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "application/json" = browser;

    "application/pdf" = [ "org.gnome.Evince.desktop" ];
  };
in {
  options.programs.shanesveller.home.enable = mkEnableOption "home";

  config = mkIf cfg.enable {
    home.packages = lib.optionals (pkgs.stdenv.isLinux) [ pkgs.xdg_utils ];

    home.stateVersion = "20.09";

    manual.manpages.enable = true;

    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;

    xdg = (if pkgs.stdenv.isLinux then {
      mimeApps = {
        enable = true;
        defaultApplications = associations;
        associations.added = associations;
      };
    } else
      { });
  };
}
