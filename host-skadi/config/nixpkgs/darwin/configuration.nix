{ pkgs, ... }: {
  imports = [ ../../../../tag-nix-darwin/config/nixpkgs/darwin/base.nix ];

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 12;

  # https://pgtune.leopard.in.ua/#/
  services.postgresql.extraConfig = ''
    # DB Version: 12
    # OS Type: mac
    # DB Type: web
    # Total Memory (RAM): 4 GB
    # CPUs num: 6
    # Connections num: 100
    # Data Storage: ssd

    max_connections = 100
    shared_buffers = 1GB
    effective_cache_size = 3GB
    maintenance_work_mem = 256MB
    checkpoint_completion_target = 0.9
    wal_buffers = 16MB
    default_statistics_target = 100
    random_page_cost = 1.1
    work_mem = 3495kB
    min_wal_size = 1GB
    max_wal_size = 4GB
    max_worker_processes = 6
    max_parallel_workers_per_gather = 3
    max_parallel_workers = 6
    max_parallel_maintenance_workers = 3
  '';

  shanesveller.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
  };
}
