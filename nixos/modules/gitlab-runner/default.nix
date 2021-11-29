{ ... }:

{
  fileSystems."/var/lib/gitlab-runner" = {
    device = "rpool/data/gitlab-runner";
    fsType = "zfs";
  };

  services.gitlab-runner = {
    configFile = "/etc/gitlab-runner/config.toml";
    enable = true;
    gracefulTermination = true;
    gracefulTimeout = "15min";
  };
}
