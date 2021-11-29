{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.kube;

  dive = pkgs.callPackage ../pkgs/dive { };
  docker-show-context = pkgs.callPackage ../pkgs/docker-show-context { };
  gojsontoyaml = pkgs.callPackage ../pkgs/gojsontoyaml { };
  jsonnet-bundler = pkgs.callPackage ../pkgs/jsonnet-bundler { };
  kubeseal = pkgs.callPackage ../pkgs/kubeseal { };

  velero = pkgs.stdenv.mkDerivation {
    name = "velero";
    version = "0.11.0";

    # https://github.com/heptio/velero/releases
    # nix-prefetch-url https://github.com/heptio/velero/releases/download/v0.11.0/velero-v0.11.0-darwin-amd64.tar.gz
    src = pkgs.fetchurl {
      url =
        "https://github.com/heptio/velero/releases/download/v0.11.0/velero-v0.11.0-darwin-amd64.tar.gz";
      sha256 = "1rlxad155z2sc17mxz0xr6gdgsjm2m7ig54n5rrk6375xmgxh7s2";
    };
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ../velero $out/bin/velero
      chmod +x $out/bin/velero
    '';
  };
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
        # docker-machine-xhyve
        docker-show-context
        # heptio-ark # lags in nix
        k9s
        kind
        # kops # lags in nix
        # ksonnet # lags in nix
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
        # click
        # fluxctl
        flux2
        gojsontoyaml
        # helmfile
        # istioctl
        go-jsonnet
        jsonnet-bundler
        # kubernetes-helm
        kubeseal
        tanka
        velero
      ] ++ pkgs.lib.optionals (cfg.work) [ kubeseal ];
    home.sessionVariables = { MINIKUBE_IN_STYLE = "false"; };
  };
}
