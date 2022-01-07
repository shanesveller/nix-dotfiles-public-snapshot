{ pkgs, ... }:

let
  makeCacheContainer = namespace: port: REGISTRY_PROXY_REMOTEURL: {
    autoStart = true;
    ephemeral = true;
    config = { ... }: {
      services.dockerRegistry.enable = true;
      services.dockerRegistry.enableGarbageCollect = true;
      services.dockerRegistry.enableRedisCache = false;
      services.dockerRegistry.port = port;
      services.dockerRegistry.extraConfig = {
        inherit REGISTRY_PROXY_REMOTEURL;
      };
    };
    bindMounts = {
      "/var/lib/docker-registry" = {
        hostPath = "/srv/docker-registry-caches/${namespace}";
        isReadOnly = false;
      };
    };
  };
in {
  containers.dockerHubProxy =
    makeCacheContainer "docker" 5001 "https://registry-1.docker.io";
  containers.gcrProxy = makeCacheContainer "docker" 5003 "https://gcr.io";
  containers.ghcrProxy = makeCacheContainer "docker" 5002 "https://ghcr.io";

  environment.systemPackages = with pkgs; [ docker-compose ];

  services.dockerRegistry = {
    enable = true;
    enableDelete = true;
    enableGarbageCollect = true;
    garbageCollectDates = "daily";
    listenAddress = "0.0.0.0";
  };

  systemd.services = {
    "container@dockerHubProxy".unitConfig.RequiresMountFor =
      "/srv/docker-registry-caches";
    "container@gcrProxy".unitConfig.RequiresMountFor =
      "/srv/docker-registry-caches";
    "container@ghcrProxy".unitConfig.RequiresMountFor =
      "/srv/docker-registry-caches";
  };

  users.extraUsers.shane = { extraGroups = [ "docker" ]; };

  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  # Openshift `oc cluster up`
  # virtualisation.docker.extraOptions = "--insecure-registry=172.30.0.0/16";
  virtualisation.docker.package = pkgs.docker;
  virtualisation.docker.storageDriver = "overlay2";
}
