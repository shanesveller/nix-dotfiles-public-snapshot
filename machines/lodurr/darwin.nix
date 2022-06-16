{ pkgs, ... }: {
  imports = [ ../../darwin/profiles/base ];

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 10;

  shanesveller.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
  };

  services.redis.enable = true;
}
