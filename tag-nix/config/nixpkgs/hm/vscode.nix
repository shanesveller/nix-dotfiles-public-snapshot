{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.vscode;
in {
  # TODO: option for overlay, or extract overlay
  options.programs.shanesveller.vscode.enable = mkEnableOption "VS Code";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = !pkgs.stdenv.isDarwin;

      extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        # TODO: cross-module config lookup
        WakaTime.vscode-wakatime
      ];

      userSettings = {
        extensions.autoUpdate = true;
        extensions.showRecommendationsOnlyOnDemand = true;
        git.autofetch = false;
        npm.fetchOnlinePackageInfo = false;
        plantuml.render = "PlantUMLServer";
        plantuml.server = "http://localhost:8080/";
        sync.askGistName = false;
        sync.autoDownload = false;
        sync.autoUpload = false;
        sync.forceDownload = false;
        sync.gist = "3791de17febc30be454ef1cae49e9460";
        sync.host = "";
        sync.pathPrefix = "";
        sync.quietSync = false;
        sync.removeExtensions = true;
        sync.syncExtensions = true;
        telemetry.enableCrashReporter = false;
        telemetry.enableTelemetry = false;
        workbench.colorTheme = "Base16 Dark Tomorrow";
        workbench.enableExperiments = false;
        workbench.settings.enableNaturalLanguageSearch = false;
        window.zoomLevel = 1;
        workbench.statusBar.feedback.visible = false;
      };
    };
  };
}
