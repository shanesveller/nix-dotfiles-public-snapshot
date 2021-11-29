{ pkgs, ... }:

let
  mkCacheConfig = remoteUrl:
    pkgs.writeTextFile {
      name = "config.yml";
      text = ''
        version: 0.1
        log:
          fields:
            service: registry
        storage:
          cache:
            blobdescriptor: inmemory
          filesystem:
            rootdirectory: /var/lib/registry
        delete:
          enabled: true
        http:
          addr: :5000
          headers:
            X-Content-Type-Options: [nosniff]
        health:
          storagedriver:
            enabled: true
            interval: 30s
            threshold: 3
        proxy:
          remoteurl: ${remoteUrl}
      '';
    };

  # Credit: https://discourse.nixos.org/t/deploying-docker-containers-declaratively/693/5
  mkCacheService = serviceName: port: remoteUrl:
    let
      image = "registry:2";
      config = mkCacheConfig remoteUrl;
    in {
      description = "Docker Registry Cache - ${remoteUrl}";
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" ];
      requires = [
        "docker.service"
        "docker.socket"
        "var-lib-docker\\x2dregistry.mount"
      ];
      script = ''
        exec ${pkgs.docker}/bin/docker run \
          --rm \
          --publish=${toString port}:5000 \
          --name=${serviceName} \
          --network=cached \
          --volume=${config}:/etc/docker/registry/config.yml \
          --volume=${serviceName}:/var/lib/registry \
          ${image}
      '';
      preStop = "${pkgs.docker}/bin/docker stop ${serviceName}";
      reload = "${pkgs.docker}/bin/docker restart ${serviceName}";
      restartTriggers = [ config ];
      serviceConfig = {
        ExecStartPre = [
          "-${pkgs.docker}/bin/docker rm -f ${serviceName}"
          "-${pkgs.docker}/bin/docker volume create ${serviceName}"
        ];
        ExecStopPost = "-${pkgs.docker}/bin/docker rm -f ${serviceName}";
        # TimeoutStartSec = 0;
        # TimeoutStopSec = 120;
        Restart = "always";
      };
    };
in {
  environment.systemPackages = with pkgs; [ docker-compose ];

  services.dockerRegistry = {
    enable = false;
    enableDelete = true;
    enableGarbageCollect = true;
    garbageCollectDates = "daily";
    listenAddress = "0.0.0.0";
  };

  systemd.services = {
    docker.unitConfig.RequiresMountFor = "/var/lib/docker";

    docker-hub-registry-cache =
      mkCacheService "registry.localhost" 5000 "https://registry-1.docker.io";
    github-registry-cache =
      mkCacheService "ghcr-registry.localhost" 5001 "https://ghcr.io";
    google-registry-cache =
      mkCacheService "gcr-registry.localhost" 5002 "https://gcr.io";
  };

  users.extraUsers.shane = { extraGroups = [ "docker" ]; };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  # Openshift `oc cluster up`
  # virtualisation.docker.extraOptions = "--insecure-registry=172.30.0.0/16";
  virtualisation.docker.package = pkgs.docker;
  virtualisation.docker.storageDriver = "overlay2";
}
