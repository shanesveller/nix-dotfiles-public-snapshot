{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.kube;

  dive = pkgs.callPackage ../pkgs/dive.nix { };
  docker-show-context = pkgs.callPackage ../pkgs/docker-show-context.nix { };
  gojsontoyaml = pkgs.callPackage ../pkgs/gojsontoyaml.nix { };
  jsonnet-bundler = pkgs.callPackage ../pkgs/jsonnet-bundler.nix { };
  kubeseal = pkgs.callPackage ../pkgs/kubeseal.nix { };
in {
  options.programs.shanesveller.kube.enable = mkEnableOption "Kubernetes";
  options.programs.shanesveller.kube.home =
    mkEnableOption "home-specific Kubernetes config";
  options.programs.shanesveller.kube.work =
    mkEnableOption "work-specific Kubernetes config";

  config = mkIf cfg.enable {
    # TODO: Overlay
    home.packages = with pkgs;
      [
        dive
        docker-show-context
        k9s
        kind
        kubectl
        kubectx
        kubernetes-helm # lags in nix
        kubeval
        kustomize # lags in nix
        minikube
        stern
        # telepresence # non-functional in OSX?
      ] ++ pkgs.lib.optionals (stdenv.isLinux) [ google-cloud-sdk kube3d ]
      ++ pkgs.lib.optionals (cfg.home) [
        gojsontoyaml
        go-jsonnet
        jsonnet-bundler
        kubeseal
      ] ++ pkgs.lib.optionals (cfg.work) [ kubeseal ];
    home.sessionVariables = { MINIKUBE_IN_STYLE = "false"; };
  };
}
