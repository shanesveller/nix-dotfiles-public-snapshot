{ pkgs, ... }: {
  imports = [ ../../../../tag-nix-darwin/config/nixpkgs/darwin/base.nix ];

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 12;

  shanesveller.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
  };
}
